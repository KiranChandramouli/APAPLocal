* @ValidationCode : MjoxNjQzMjAzMjU5OkNwMTI1MjoxNjg5MjQyMTUzNDE2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:25:53
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
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion             ++ TO +=
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.INP.TFS.LINES.AMT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.INP.TFS.LINES.AMT
*--------------------------------------------------------------------------------------------------------
*Description       : This is an INPUT routine, the routine validates if the total amount in the local
*                    field is equal to the sum of amounts of all the TFS lines
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 19 July 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    Y.TOT.AMT = 0

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB CHECK.AMOUNT

RETURN
*--------------------------------------------------------------------------------------------------------
*************
CHECK.AMOUNT:
*************
    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.TXN.AMT.POS>) THEN
        RETURN
    END

    Y.TXN.AMTS = R.NEW(TFS.AMOUNT)

    LOOP
        REMOVE Y.AMT FROM Y.TXN.AMTS SETTING Y.AMT.POS
    WHILE Y.AMT:Y.AMT.POS
        Y.TOT.AMT += Y.AMT ;*R22 Auto Conversion
    REPEAT

    IF Y.TOT.AMT NE R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.TXN.AMT.POS> THEN
        AF = TFS.AMOUNT
        ETEXT = 'EB-AMT.NE.TFS.LINES'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********************
FIND.MULTI.LOCAL.REF:
********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'T24.FUND.SERVICES'
    FLD.ARRAY  = 'L.TFS.TXN.AMT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TFS.TXN.AMT.POS  =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of PRogram
