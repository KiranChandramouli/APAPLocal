* @ValidationCode : MjotMzg2ODYxMTY6Q3AxMjUyOjE2ODc3ODU1NDYyNDA6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Jun 2023 18:49:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.UPDATE.BRANCH.STK
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.AUT.UPDATE.BRANCH.STK
*--------------------------------------------------------------------------------------------------------
*Description  : This is an authorisation routine to update STOCK.REGISTER
*Linked With  : STOCK.ENTRY,REDO.CARDMV
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 11 Mar 2011    Swaminathan            ODR-2010-03-0400         Initial Creation
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*26/06/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION             VM TO @VM
*26/06/2023      SURESH                     MANUAL R22 CODE CONVERSION         VARIABLE NAME MODIFIED
*----------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.REDO.BRANCH.REQ.STOCK

    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.BRANCH.REQ.STOCK = 'F.REDO.BRANCH.REQ.STOCK'
    F.BRANCH.REQ.STOCK = ''
    CALL OPF(FN.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK)

RETURN

*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------


    R.BRANCH.REQ.STOCK = ''
    Y.INTIAL = ''

    Y.TOT.CARD.SERIES = DCOUNT(R.NEW(STO.ENT.STOCK.SERIES),@VM)

    Y.INIT.CARD.SERIES = 1
    LOOP
    WHILE Y.INIT.CARD.SERIES LE Y.TOT.CARD.SERIES
        Y.STOCK.SERIES = R.NEW(STO.ENT.STOCK.SERIES)<1,Y.INIT.CARD.SERIES>
        Y.STK.QTY = R.NEW(STO.ENT.STOCK.QUANTITY)<1,Y.INIT.CARD.SERIES>
        CALL F.READ(FN.BRANCH.REQ.STOCK,Y.STOCK.SERIES,R.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK,Y.ERR)
        R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK> = Y.STK.QTY ;*R22 MANUAL CODE CONVERSION - START
        R.BRANCH.REQ.STOCK<BRAN.STK.TXN.DATE> = TODAY
        R.BRANCH.REQ.STOCK<BRAN.STK.TXN.DATE> = R.NEW(STO.ENT.IN.OUT.DATE)
*<<<<<<<<<<<<<<<<<<<<<<<<<<< CHANGES HAS TO BE CONFIRM>>>>>>>>>>>>>>>>>>>>>>>*
        CALL F.READ(FN.BRANCH.REQ.STOCK,Y.STOCK.SERIES,R.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK,Y.ERR)
        R.BRANCH.REQ.STOCK<BRAN.STK.TXN.DATE> = R.NEW(STO.ENT.IN.OUT.DATE)
        Y.INTIAL = R.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY>
        IF Y.INTIAL THEN
            Y.COUNT = DCOUNT(Y.INTIAL,@VM)
            Y.STK.QTY =  Y.INTIAL<1,Y.COUNT> + Y.STK.QTY
            R.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY,Y.COUNT> = Y.STK.QTY
        END
        Y.INTIAL = R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK>
        R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK> = Y.INTIAL + Y.STK.QTY
* R.BRANCH.REQ.STOCK<BRAN.STK.LAST.STOCK.REQ>=Y.STK.QTY + R.BRANCH.REQ.STOCK<BRAN.STK.LAST.STOCK.REQ> ;*R22 MANUAL CODE CONVERSION - END
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        CALL F.WRITE(FN.BRANCH.REQ.STOCK,Y.STOCK.SERIES,R.BRANCH.REQ.STOCK)
        Y.INIT.CARD.SERIES + = 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------
END
