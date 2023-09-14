* @ValidationCode : MjoxMTg5NTM1OTk5OkNwMTI1MjoxNjg0ODM2MDU0NDUzOklUU1M6LTE6LTE6MTY2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 166
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.VAL.POST.AUTH.NUM
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.V.VAL.POST.AUTH.NUM
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.V.VAL.POST.AUTH.NUM is an validation routine attached to the local reference
*                    field L.TT.POS.AUTHNM, the routine selects the FUNDS.TRANFER file with AT.AUTH.CODE
*                    eaual to the value entered in the field L.TT.POS.AUTHNM, then the DEBIT.ACCT.NO of the
*                    FUNDS.TRANSFER is populated in the ACCOUNT.2 of the TELLER
*Linked With       : Version - TELLER,REDO.DC.CASH
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : FUNDS.TRANSFER                   As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 11 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  NO CHANGE
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    SEL.CMD = 'SELECT ':FN.FUNDS.TRANSFER:' WITH AT.AUTH.CODE EQ ':COMI
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    FUNDS.TRANSFER.ID = SEL.LIST<1>
    GOSUB READ.FUNDS.TRANSFER

    R.NEW(TT.TE.ACCOUNT.2) = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>

RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.FUNDS.TRANSFER:
********************
* In this para of the code, file FUNDS.TRANSFER is read
    R.FUNDS.TRANSFER  = ''
    FUNDS.TRANSFER.ER = ''
    CALL F.READ(FN.FUNDS.TRANSFER,FUNDS.TRANSFER.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
