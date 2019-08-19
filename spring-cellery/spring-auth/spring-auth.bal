//   Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

// Cell file for Pet Store Sample Backend.
// This Cell encompasses the components which deals with the business logic of the Pet Store

import celleryio/cellery;

public function build(cellery:ImageName iName) returns error? {

    // Article Component
    // This component deals with all the article related functionality.
    cellery:Component authorComponent = {
        name: "author",
        source: {
            image: "athukorala/spring-auth"
        },
        ingresses: {
            orders: <cellery:HttpApiIngress>{
                port: 8081,
                context: "controller",
                expose: "local",
                definition:{
                    resources:[
                        {
                            path:"/*",
                            method:"GET"
                        }
                    ]
                }
            }
        }
    };

    // Cell Initialization
    cellery:CellImage authorCell = {
        components: {
            author: authorComponent
        }
    };
    return cellery:createImage(authorCell, untaint iName);
}

public function run(cellery:ImageName iName, map<cellery:ImageName> instances) returns error? {
    cellery:CellImage authorCell = check cellery:constructCellImage(untaint iName);
    return cellery:createInstance(authorCell, iName, instances);
}

