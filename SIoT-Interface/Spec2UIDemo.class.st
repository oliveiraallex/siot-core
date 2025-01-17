Class {
	#name : #Spec2UIDemo,
	#superclass : #SpPresenter,
	#instVars : [
		'menu',
		'list',
		'page',
		'selectedPage'
	],
	#category : #'SIoT-Interface'
}

{ #category : #'user interface' }
Spec2UIDemo class >> menuExamplesOn: aBuilder [
	"Add a custom menu item to the world menu"

	<worldMenu>
	(aBuilder item: #'Spec2 examples')
		iconName: #smallHelpIcon;
		parent: #Help;
		order: 3.5;
		help: 'Open Spec2 demo browser.';
		action: [ self open ].
	aBuilder withSeparatorAfter	
]

{ #category : #'instance creation' }
Spec2UIDemo class >> on: aModel [

	^ self basicNew 
		model: aModel;
		initialize;
		yourself.
]

{ #category : #specs }
Spec2UIDemo class >> open [
	<example>
	
	^ self new
		openWithSpec
]

{ #category : #accessing }
Spec2UIDemo >> addItemTo: aGroup [
	aGroup
		addItem: [ :item | 
			item
				name: 'Dynamic';
				icon: (self iconNamed: #delete);
				action: [ aGroup menuItems remove: item.
					self needRebuild: false.
					self buildWithSpec ] ].
	self needRebuild: false.
	self buildWithSpec
]

{ #category : #accessing }
Spec2UIDemo >> availablePages [
	^ SpDemoPage availablePages
]

{ #category : #initialization }
Spec2UIDemo >> connectPresenters [

	list selectItem: self selectedPage.
	list whenSelectionChangedDo: [ :selection | 
		selection selectedItem
			ifNotNil: [ :newPageClass | 
				newPageClass = self selectedPage
					ifFalse: [ 
						self selectedPage: newPageClass.
						page
							removeAll; 
							add: (self instantiate: newPageClass);
							yourself ] ]
			ifNil: [ 
				"Avoid the user to have no page selected at all." 
				list setSelectedItem: self selectedPage ] ]
]

{ #category : #accessing }
Spec2UIDemo >> defaultPage [

	^ self availablePages first.
]

{ #category : #api }
Spec2UIDemo >> initialExtent [

	| fontWidth rowHeight |
	fontWidth := (StandardFonts defaultFont widthOfString: 'M').
	rowHeight := self class inputTextHeight.

	^ (90@24) * (fontWidth @ rowHeight)
	
]

{ #category : #initialization }
Spec2UIDemo >> initializePresenters [

	menu := self mainMenu.
	list := self newList.
	page := SpBoxLayout newTopToBottom 
		add: (self instantiate: (selectedPage := self availablePages first));
		yourself.

	self layout: (SpBoxLayout newTopToBottom
		add: menu expand: false;
		add: (SpPanedLayout newLeftToRight
			positionOfSlider: 200;
			add: list;
			add: page;
			yourself);
		yourself).

	menu addKeybindingsTo: self.

	list
		items: self availablePages;
		display: [ :item | item pageName ];
		contextMenu:
			(self newMenu
				addItem: [ :item | 
					item
						name: 'Browse';
						icon: (self iconNamed: #smallHelp);
						action: [ list selectedItem browse ] ];
				addItem: [ :item | 
					item
						name: 'Browse presenter';
						icon: (self iconNamed: #smallHelp);
						action: [ list selectedItem new pageClass browse ] ];
				yourself).

	self focusOrder
		add: list;
		add: page
]

{ #category : #accessing }
Spec2UIDemo >> list [
	^ list
]

{ #category : #accessing }
Spec2UIDemo >> list: anObject [
	list := anObject
]

{ #category : #initialization }
Spec2UIDemo >> mainMenu [
	| aMenu |
	aMenu := self newMenuBar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'File';
						icon: (self iconNamed: #openIcon);
						subMenu: self subMenu ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Open file';
						icon: (self iconNamed: #openIcon);
						action: [ self inform: 'Open File' ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Save File';
						icon: (self iconNamed: #smallSaveIcon);
						action: [ self inform: 'Save File' ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Print file';
						icon: (self iconNamed: #smallPrintIcon);
						action: [ self inform: 'Print file' ] ] ];
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Undo';
						icon: (self iconNamed: #smallUndoIcon);
						action: [ self inform: 'Undo' ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Redo';
						icon: (self iconNamed: #smallRedoIcon);
						action: [ self inform: 'Redo' ] ] ];
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Add menu item';
						icon: (self iconNamed: #add);
						action: [ self addItemTo: group ] ] ].
	^ aMenu
]

{ #category : #accessing }
Spec2UIDemo >> menu [
	^ menu
]

{ #category : #accessing }
Spec2UIDemo >> menu: anObject [
	menu := anObject
]

{ #category : #accessing }
Spec2UIDemo >> page [
	^ page
]

{ #category : #accessing }
Spec2UIDemo >> page: anObject [
	page := anObject
]

{ #category : #accessing }
Spec2UIDemo >> selectedPage [
	^ selectedPage
]

{ #category : #accessing }
Spec2UIDemo >> selectedPage: anObject [
	selectedPage := anObject
]

{ #category : #initialization }
Spec2UIDemo >> subMenu [
	^ self newMenu
		addItem: [ :item | 
			item
				name: 'Open';
				icon: (self iconNamed: #openIcon);
				shortcut: $o meta;
				action: [ self inform: 'Open' ] ];
		addItem: [ :item | 
			item
				name: 'Save';
				icon: (self iconNamed: #smallSaveIcon);
				shortcut: $s meta;
				action: [ self inform: 'Save' ] ];
		addItem: [ :item | 
			item
				name: 'Print';
				shortcut: $p meta;
				icon: (self iconNamed: #smallPrintIcon);
				action: [ self inform: 'Print' ] ];
		addItem: [ :item | 
			item
				name: 'Close';
				shortcut: $c meta;
				icon: (self iconNamed: #smallCancelIcon);
				action: [ self inform: 'Kill' ] ];
		yourself
]

{ #category : #api }
Spec2UIDemo >> title [
	
	^ 'Spec UI Framework Demo'.
]
