Extension { #name : #FamixOTelModel }

{ #category : #'*TracePlot' }
FamixOTelModel >> methodSignatures [
	^ self spans collect: #methodSignature
]

{ #category : #'*TracePlot' }
FamixOTelModel >> spans [
	^ self trace spans
]

{ #category : #'*TracePlot' }
FamixOTelModel >> trace [
	^ (self allWithType: FamixOTelTrace) first
]
