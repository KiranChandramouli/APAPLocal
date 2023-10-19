* @ValidationCode : MjotMTgyODQ4MjMzMTpDcDEyNTI6MTY4OTI0MTM1MjI0NDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:12:32
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
*13/07/2023      Conversion tool            R22 Auto Conversion             VM TO @VM
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.AUT.GEN.DEAL.SLIP
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.GEN.DEAL.SLIP
*--------------------------------------------------------------------------------------------------------
*Description       : This is an AUTHORISATION routine, the routine is used to generate deal slips
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*                    REDO.TFS.TRANSACTION.DETAILS        As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date              Who                  Reference                 Description
*   ------            -----               -------------              -------------
* 22 Dec 2010     Shiva Prasad Y       ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.TFS.TRANSACTION.DETAILS
    $INSERT I_GTS.COMMON
*--------------------------------------------------------------------------------------------------------
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
    FN.REDO.TFS.TRANSACTION.DETAILS = 'F.REDO.TFS.TRANSACTION.DETAILS'
    F.REDO.TFS.TRANSACTION.DETAILS  = ''
    CALL OPF(FN.REDO.TFS.TRANSACTION.DETAILS,F.REDO.TFS.TRANSACTION.DETAILS)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    OFS$DEAL.SLIP.PRINTING = 1
    V$FUNCTION = 'I'

    REDO.TFS.TRANSACTION.DETAILS.ID = 'SYSTEM'
    GOSUB READ.REDO.TFS.TRANSACTION.DETAILS

    Y.TXN.CODES = R.REDO.TFS.TRANSACTION.DETAILS<TFS.TXN.DET.TFS.TRANSACTION>

    Y.TXN.COUNT = DCOUNT(Y.TXN.CODES,@VM)
    Y.TXN.START = 1

    LOOP
    WHILE Y.TXN.START LE Y.TXN.COUNT
        IF R.REDO.TFS.TRANSACTION.DETAILS<TFS.TXN.DET.DEAL.SLIP.FMT,Y.TXN.START> THEN
            CALL PRODUCE.DEAL.SLIP(R.REDO.TFS.TRANSACTION.DETAILS<TFS.TXN.DET.DEAL.SLIP.FMT,Y.TXN.START>)
        END
        Y.TXN.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
**********************************
READ.REDO.TFS.TRANSACTION.DETAILS:
**********************************
* In this para of the code, file REDO.TFS.TRANSACTION.DETAILS is read
    R.REDO.TFS.TRANSACTION.DETAILS  = ''
    REDO.TFS.TRANSACTION.DETAILS.ER = ''
*  CALL F.READ(FN.REDO.TFS.TRANSACTION.DETAILS,REDO.TFS.TRANSACTION.DETAILS.ID,R.REDO.TFS.TRANSACTION.DETAILS,F.REDO.TFS.TRANSACTION.DETAILS,REDO.TFS.TRANSACTION.DETAILS.ER) ;*Tus Start
    CALL CACHE.READ(FN.REDO.TFS.TRANSACTION.DETAILS,REDO.TFS.TRANSACTION.DETAILS.ID,R.REDO.TFS.TRANSACTION.DETAILS,REDO.TFS.TRANSACTION.DETAILS.ER) ; * Tus End

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
