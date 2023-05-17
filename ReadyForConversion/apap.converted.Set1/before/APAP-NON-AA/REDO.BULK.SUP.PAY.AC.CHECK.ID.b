*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BULK.SUP.PAY.AC.CHECK.ID
************************************************************************
* ID level validations
************************************************************************
* 29/06/04 - EN_10002298
*            New Version
*
************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE

* Validation and changes of the ID entered.  Set ERROR to 1 if in error
  E = ''

  ID.NEW = COMI
  CALL EB.FORMAT.ID("BKAC")   ;* Format to BKOTyydddNNNNN;NN

  RETURN
END
