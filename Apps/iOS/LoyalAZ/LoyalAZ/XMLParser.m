//
//  XMLParser.m
//  LoyalAZ
//

#import "XMLParser.h"


@implementation XMLParser

static NSMutableString *xmlString; 

static id tempObject = nil;

+(NSMutableString *)ObjectToXml:(id)targetObject
{
    xmlString = [[NSMutableString alloc]init];
    [self GetObjectVariables:targetObject];
    return xmlString;
}


+(id)XmlToObject:(NSString *)xmlStringToParse
{
    NSError *err;
    tempObject = nil;
    xmlStringToParse = [xmlStringToParse stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CXMLDocument *parser = [[CXMLDocument alloc]initWithXMLString:xmlStringToParse options:0 error:&err];
    [self FillObject:parser.rootElement];
    //[parser release];
    return tempObject;
}

+(NSString *)GetNodeValue:(NSString *)XMLSource nodePath:(NSString *)path;
{
    XMLSource = [XMLSource stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSError *err;
    CXMLDocument *parser = [[CXMLDocument alloc]initWithXMLString:XMLSource options:0 error:&err];
    CXMLNode *node = [parser nodeForXPath:path error:&err];
    //[parser release];
    return node.stringValue;
}

+(void)FillObject:(CXMLElement*)elementToParse
{
    //NSLog(@"Element=%@",elementToParse.name);
    if(tempObject==nil)
    {
        NSString *className = elementToParse.name;
//        NSLog(@"CLASS1==%@",className);
        tempObject = [[NSClassFromString(className) alloc] init];
        
        for(int attributeCount=0;attributeCount<elementToParse.attributes.count;attributeCount++)
        {
            NSString *attributeValue = [[elementToParse.attributes objectAtIndex:attributeCount]stringValue];
            const char *attributeName = [[[elementToParse.attributes objectAtIndex:attributeCount]name] UTF8String];
            //NSLog(@"ATTRIB =%@",[[elementToParse.attributes objectAtIndex:attributeCount]stringValue]);
            object_setInstanceVariable(tempObject, attributeName,[attributeValue copy]);
        }
    }
    else 
    {
        //attributes needs to be looped for current object first.
        NSString *className = elementToParse.name;
        //NSString *className = [elementToParse.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"CLASS2==%@",className);
        if([className isEqualToString:@"text"]==NO)
        {
            
            
            id tObject = nil;

            tObject = [[NSClassFromString(className) alloc] init]; // check to be implemented here to see if class exists or not
            
//            if(tObject==nil)
//                return;
            
//            tObject = NSClassFromString(className); // check to be implemented here to see if class exists or not
//            if(tObject!=NULL)
//            {
//                tObject = [[NSClassFromString(className) alloc] init]; // check to be implemented here to see if class exists or not
//            }
//            else
//            {
//                return;
//            }
            
            //        if(tObject==nil)
            //            return;
            for(int attributeCount=0;attributeCount<elementToParse.attributes.count;attributeCount++)
            {
                NSString *attributeValue = [[elementToParse.attributes objectAtIndex:attributeCount]stringValue];
                const char *attributeName = [[[elementToParse.attributes objectAtIndex:attributeCount]name] UTF8String];
                //NSLog(@"ATTRIB =%@",[[elementToParse.attributes objectAtIndex:attributeCount]stringValue]);
                object_setInstanceVariable(tObject, attributeName,[attributeValue copy]);
            }
            NSString *varName = elementToParse.name;
            varName = [varName lowercaseString];
            object_setInstanceVariable(tempObject, [varName UTF8String],tObject);
            // now parse the child elements of the current object.
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            for(int cCount=0;cCount<elementToParse.childCount;cCount++)
            {
                NSString *clsName = [[elementToParse childAtIndex:cCount]name];
                if([clsName isEqualToString:@"text"]==NO)
                {
                    id childObject1 = [[NSClassFromString(clsName) alloc] init];
                    CXMLElement *element1 =(CXMLElement*) [elementToParse childAtIndex:cCount];
                    for(int attributeCount=0;attributeCount<element1.attributes.count;attributeCount++)
                    {
                        NSString *attributeValue1 = [[element1.attributes objectAtIndex:attributeCount]stringValue];
                        const char *attributeName1 = [[[element1.attributes objectAtIndex:attributeCount]name] UTF8String];
                        object_setInstanceVariable(childObject1, attributeName1,[attributeValue1 copy]);
                    }
                    [tempArray addObject:childObject1];
                }
                
            }
            if([tempArray count]>0)
            {
                //object_setClass(tempObject, [NSString stringWithUTF8String:object_getClassName(tempArray)]);
                object_setInstanceVariable(tempObject, [elementToParse.name UTF8String],tempArray);
            }
        }
    }
    
    //NSLog(@"%@",tempObject);
    for(int childCount=0;childCount<elementToParse.childCount;childCount++)
    {
        CXMLElement *nextElement =(CXMLElement*) [elementToParse childAtIndex:childCount];
        [self FillObject:nextElement];
        //NSLog(@"ELEM=%@",nextElement.name);
        //NSLog(@"%@",[[elementToParse childAtIndex:childCount]name]);
    }
}


+(void)GetChildNodes:(CXMLNode*)nodeToParse
{
    
    if(tempObject==nil)
    {
        tempObject = [[NSClassFromString(nodeToParse.name) alloc] init];
    }
    
    //NSLog(@"Node = %@",nodeToParse.name);
    
    
    for(int childCount=0;childCount<nodeToParse.childCount;childCount++)
    {
        CXMLNode *currentNode = [nodeToParse childAtIndex:childCount];
        //NSLog(@"Node Name = %@", currentNode.name);
        if(currentNode.childCount>0)
            [self GetChildNodes:currentNode];
    }
    
}



+(void)GetObjectVariables:(id)targetObject
{
    
    unsigned int varCount;
    
    [xmlString appendString:@"<"];
    NSString *className =[NSString stringWithUTF8String:object_getClassName(targetObject)];
    
    [xmlString appendString:className];
    
    Ivar *vars = class_copyIvarList([object_getClass(targetObject) class], &varCount);
    
    NSMutableArray *arrayObjects = [[NSMutableArray alloc]init];
    NSMutableArray *arrayObjectNames = [[NSMutableArray alloc]init];
    
    NSMutableArray *customObjects = [[NSMutableArray alloc]init];
    NSMutableArray *customObjectsNames = [[NSMutableArray alloc]init];
    NSString *attr;
    
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        
        const char* name = ivar_getName(var);
        const char* typeEncoding = ivar_getTypeEncoding(var);
        
        NSString *typeName = [NSString stringWithUTF8String:typeEncoding];
        NSString *variableName = [NSString stringWithUTF8String:name];
        
        id variableValue = nil;
        
        NSString *attributeValue;
        object_getInstanceVariable(targetObject, name, (void**)&variableValue);
        
        if([typeName compare:@"i"]==0)
        {
            int numericValue;
            object_getInstanceVariable(targetObject, name, (void**)&numericValue);
            attributeValue = [[NSString alloc]initWithFormat:@"%d",numericValue];
            attr = [[NSString alloc]initWithFormat:@" %@=\"%@\" ",variableName,attributeValue];
            [xmlString appendString:attr];
            
        }
        else if([typeName compare:@"@\"NSString\""]==0 || [typeName compare:@"@\"NSDate\""]==0 ) 
        {
            if(variableValue==NULL)
                variableValue=@"";
            attributeValue = [[NSString alloc]initWithFormat:@"%@",variableValue];
            attr = [[NSString alloc]initWithFormat:@" %@=\"%@\" ",variableName,attributeValue];
            [xmlString appendString:attr];
        }
        else if([typeName compare:@"@\"NSMutableArray\""]==0)
        {

            if(variableValue!=nil)
            {
                [arrayObjectNames addObject:variableName];
                [arrayObjects addObject:(NSMutableArray *)variableValue];
            }
        }
        else 
        {
            [customObjects addObject:variableValue];
            [customObjectsNames addObject:variableName];
        }
    }
    
    [xmlString appendString:@">"];
    
    for(int arrayObjectCount=0;arrayObjectCount<customObjects.count;arrayObjectCount++)
    {
        id customObject = [customObjects objectAtIndex:arrayObjectCount];
        [self GetObjectVariables:customObject];
    }
    
    
    for(int arrayObjectCount=0;arrayObjectCount<arrayObjectNames.count;arrayObjectCount++)
    {

        [xmlString appendString:@"<"];
        [xmlString appendString:[arrayObjectNames objectAtIndex:arrayObjectCount]];
        [xmlString appendString:@">"];
        
        if(arrayObjects.count>0)
        {
            NSMutableArray *arrObj = [arrayObjects objectAtIndex:arrayObjectCount] ;
            //NSLog(@"Array got with count %d",arrObj.count);
            if(arrObj.count>0)
            {
                for(int counter=0;counter<arrObj.count;counter++)
                {
                    [self GetObjectVariables:[arrObj objectAtIndex:counter]];
                }
            }
        }
        
        [xmlString appendString:@"</"];
        [xmlString appendString:[arrayObjectNames objectAtIndex:arrayObjectCount]];
        [xmlString appendString:@">"];
    }
    
    [xmlString appendString:@"</"];
    [xmlString appendString:className];
    [xmlString appendString:@">"];
    
    free(vars);    
    
}

@end
