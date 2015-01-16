/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.0
import bb.data 1.0

NavigationPane {
    id: navPane
Page {
    titleBar: TitleBar {
        title: "Addicts à Blackberry 10 RSS"
    }
    Container {

        ListView {
            id: myListView 
            dataModel: dataModel 
            listItemComponents: [
                ListItemComponent {
                     type: "item"
                        StandardListItem {
                            title: ListItemData.title
                            description: ListItemData.pubDate
                            }
                            }
                            ]
        onTriggered: {
            var feedItem = dataModel.data(indexPath);
            var page = detailPage.createObject();
            page.htmlContent = feedItem.description;
            navPane.push(page);
        }
        
    }
    
    attachedObjects: [
        GroupDataModel {
            id: dataModel
            
            sortingKeys: ["pubDate"]
            sortedAscending: false
            grouping: ItemGrouping.None
        },
        ComponentDefinition {
            id: detailPage
            Page {
                property alias htmlContent: detailView.html
                Container {
                    ScrollView {
                        scrollViewProperties.scrollMode: ScrollMode.Vertical
                        WebView {
                            id: detailView;
                        }
                    }
                }
            }
        },
        DataSource {
            id: dataSource
            
            source: "http://www.blackberry-10.fr/rss/"
            query: "/rss/channel/item"
            type: DataSourceType.Xml
            
            onDataLoaded: {
                dataModel.clear();
                dataModel.insertList(data)
            }
        }
    ]
    
    onCreationCompleted: {
        dataSource.load();
    }
    
    
    }    
    actions: [     
        ActionItem {
            title: "Rafraichir"
            imageSource: "asset:///images/Refresh-icon.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                dataSource.load();
            }
            
        } 
        
    ]
    
}

}


