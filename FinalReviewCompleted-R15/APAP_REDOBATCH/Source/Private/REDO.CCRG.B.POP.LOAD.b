* @ValidationCode : MjotMTE0NDI3NDAxMTpDcDEyNTI6MTY4MDY5MDQ2MTg5ODpJVFNTOi0xOi0xOjc5MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:57:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 793
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CCRG.B.POP.LOAD
*-----------------------------------------------------------------------------
*
* Load routine to setup the common area for the multi-threaded Close of Business
* job REDO.CCRG.POP
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011.04.06 - APAP B5 : ODR-2011-03-0154
*                                   First Version
*REM Just for compile
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool   R22 Auto conversion        No Changes
* 04-APR-2023      Harishvikram C   R22 Auto conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.CCRG.B.POP.COMMON
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*OPEN.FILES
*-----------------------------------------------------------------------------

* Queue Populate
    FN.REDO.CCRG.POP.QUEUE = 'F.REDO.CCRG.POP.QUEUE'
    F.REDO.CCRG.POP.QUEUE  = ''
    CALL OPF(FN.REDO.CCRG.POP.QUEUE,F.REDO.CCRG.POP.QUEUE)

* List Risk Limit by the Customer
    FN.REDO.CCRG.RL.CUSTOMER = 'F.REDO.CCRG.RL.CUSTOMER'
    F.REDO.CCRG.RL.CUSTOMER  = ''
    CALL OPF(FN.REDO.CCRG.RL.CUSTOMER,F.REDO.CCRG.RL.CUSTOMER)

*List of the Related Customer by Risk Limit
    FN.REDO.CCRG.RL.REL.CUS = 'F.REDO.CCRG.RL.REL.CUS'
    F.REDO.CCRG.RL.REL.CUS  = ''
    CALL OPF(FN.REDO.CCRG.RL.REL.CUS,F.REDO.CCRG.RL.REL.CUS)

*Balances by the Customer and Related Customers
    FN.REDO.CCRG.CONTRACT.BAL = 'F.REDO.CCRG.CONTRACT.BAL'
    F.REDO.CCRG.CONTRACT.BAL  = ''
    CALL OPF(FN.REDO.CCRG.CONTRACT.BAL,F.REDO.CCRG.CONTRACT.BAL)

*Enquiry: Distribution by Risk Limit
    FN.REDO.CCRG.RL.BAL.MAIN = 'F.REDO.CCRG.RL.BAL.MAIN'
    F.REDO.CCRG.RL.BAL.MAIN  = ''
    CALL OPF(FN.REDO.CCRG.RL.BAL.MAIN,F.REDO.CCRG.RL.BAL.MAIN)

*Enquiry: Detail by Catergory Product
    FN.REDO.CCRG.RL.BAL.DET = 'F.REDO.CCRG.RL.BAL.DET'
    F.REDO.CCRG.RL.BAL.DET  = ''
    CALL OPF(FN.REDO.CCRG.RL.BAL.DET,F.REDO.CCRG.RL.BAL.DET)

*Enquiry: Detail by Related Customer
    FN.REDO.CCRG.RL.BAL.CUS.DET = 'F.REDO.CCRG.RL.BAL.CUS.DET'
    F.REDO.CCRG.RL.BAL.CUS.DET  = ''
    CALL OPF(FN.REDO.CCRG.RL.BAL.CUS.DET,F.REDO.CCRG.RL.BAL.CUS.DET)

*Enquiry: Monitor of process
    FN.REDO.CCRG.RL.EFFECTIVE = 'F.REDO.CCRG.RL.EFFECTIVE'
    F.REDO.CCRG.RL.EFFECTIVE = ''
    CALL OPF(FN.REDO.CCRG.RL.EFFECTIVE,F.REDO.CCRG.RL.EFFECTIVE)


RETURN

END
