* @ValidationCode : Mjo3NjkyMjYyMjk6Q3AxMjUyOjE2ODE4MjgwMDQ0Mzg6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.GENERATION.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.GENERATION.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a VALIDATION routine to accepy qty of cards to generate
*Linked With  : REDO.CARD.GENERATION
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 11 SEP 2010    Swaminathan      ODR-2010-03-0400         Initial Creation
* 11-04-2023     CONVERSION TOOL  AUTO R22 CODE CONVERSION            NO CHANGES
* 11-04-2023     jayasurya H      MANUAL R22 CODE CONVERSION          NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LOCKING
    $INSERT I_F.REDO.CARD.GENERATION
    $INSERT I_F.REDO.CARD.REQUEST

    FN.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.CARD.REQUEST = ''
    CALL OPF(FN.CARD.REQUEST,F.CARD.REQUEST)

    Y.CARD.ID = ID.NEW
    CALL F.READ(FN.CARD.REQUEST,ID.NEW,R.CARD.REQUEST,F.CARD.REQUEST,Y.ERR.CR)
    Y.BRANCH.QTY =   R.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY>
    Y.QTY = R.NEW(REDO.CARD.GEN.QTY)

    IF Y.QTY GT Y.BRANCH.QTY THEN
        AF = REDO.CARD.GEN.QTY
        ETEXT= "EB-BRANCH.QTY"
        CALL STORE.END.ERROR
    END
RETURN
END
