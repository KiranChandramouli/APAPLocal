* @ValidationCode : MjoxNDgzMTQyNDEzOkNwMTI1MjoxNjgxMTEyNjY3NTkzOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:14:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.VAULT.UPD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    :
*--------------------------------------------------------------------------------------------------------
*Description  : This is an authorisation routine to update STOCK.REGISTER
*Linked With  : STOCK.ENTRY,REDO.CARDMV.VAULT
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 11 MARCH 2011    SWAMINATHAN        ODR-2010-03-0400         Initial Creation
*--------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                          VM TO @VM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.REDO.CARD.REQUEST

    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.STOCK.ENTRY = 'F.STOCK.ENTRY'
    F.STOCK.ENTRY = ''
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)

    FN.STOCK.REGISTER = 'F.STOCK.REGISTER'
    F.STOCK.REGISTER = ''
    CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)

    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

    R.STOCK.REGISTER = ''
    REG.ID = ''
    Y.NO.DAMAGE.CARD = ''
    Y.NO.LOST.CARD = ''
    Y.DAMAGE.LOST.NO = ''

RETURN

*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------
* used to update the STOCK.REGISTER for no.of card demaged
* number of demaged card details can be ontained from the local reference field created in STOCK.ENTRY application

    GOSUB GET.LOCAL.REF.FIELDS

    Y.REDO.CARD.REQUEST.ID=R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.BATCH.NO.POS>
    CALL F.READ(FN.REDO.CARD.REQUEST,Y.REDO.CARD.REQUEST.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,F.ERR)
    R.REDO.CARD.REQUEST<REDO.CARD.REQ.VAULT.SE.ID> = ID.NEW
    Y.TOT.CARD.SERIES = R.NEW(STO.ENT.STOCK.SERIES)
    Y.INIT.CARD.SERIES = 1
    LOOP
    WHILE Y.INIT.CARD.SERIES LE Y.TOT.CARD.SERIES
        Y.STOCK.SERIES = Y.TOT.CARD.SERIES<1,Y.INIT.CARD.SERIES>
        GOSUB CHECK.STOCK.VAL

        R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY,Y.INIT.CARD.SERIES> = Y.RCR.QTY - Y.STK.QTY

        Y.INIT.CARD.SERIES +=1
    REPEAT

    CALL F.WRITE(FN.REDO.CARD.REQUEST,Y.REDO.CARD.REQUEST.ID,R.REDO.CARD.REQUEST)

RETURN
*-----------------------------------------------------------------------------------
CHECK.STOCK.VAL:
*-----------------

    Y.STK.QTY = R.NEW(STO.ENT.STOCK.QUANTITY)<1,Y.INIT.CARD.SERIES>
    Y.RCR.QTY = R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY,Y.INIT.CARD.SERIES>

    IF Y.STK.QTY GT Y.RCR.QTY THEN
        AF = STO.ENT.STOCK.QUANTITY
        AV = Y.INIT.CARD.SERIES
        ETEXT = "EB-BRANCH.QTY"
        CALL STORE.END.ERROR
    END

RETURN
*-------------------------------------------------------------------------------------------------------
********************
GET.LOCAL.REF.FIELDS:
********************
*In this para of code local reference field positions are identified

    APPL.ARRAY='STOCK.ENTRY'
    FLD.ARRAY='L.SE.DAMAGED.NO':@VM:'L.SE.CARDS.LOST':@VM:'L.SE.CRD.SERIES':@VM:'L.SE.BATCH.NO'
    FLD.POS=''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.SE.DAMAGE.NO.POS   = FLD.POS<1,1>
    L.SE.CARDS.LOST.POS  = FLD.POS<1,2>
    L.SE.CRD.SERIES.POS  = FLD.POS<1,3>
    L.SE.BATCH.NO.POS    = FLD.POS<1,4>

RETURN
*--------------------------------------------------------------------------------------------------------
END
