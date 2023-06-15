* @ValidationCode : MjoxODU1MzA3OTQwOkNwMTI1MjoxNjg0ODU0MzkwNTAzOklUU1M6LTE6LTE6MjUwNjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2506
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.GET.TXN.M.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine is the load routine of the batch job REDO.B.LY.GET.TXN.M which updates F.REDO.LY.TXN.BY.MOD file
*  This routine initialises the local common variables defined in REDO.B.LY.GET.TXN.M.COMMON
*  Retrieves the details from REDO.LY.MODALITY parameter table and
*  stores it in the local common variables
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar  ODR-2009-12-0276      Initial Creation
* 30-JUL-2011   VNAVA             ODR-2011-06-0243      Update for C/I Identification
*               RMONDRAGON
* 01-AUG-2011   VNAVA                                   Adding birthday's client point generation
* 09-AUG-2011   RMONDRAGON                              Conditions for Including and Excluding Txns
*               VNAVA
* 26-DEC-2013   RMONDRAGON                              Redefinition
* Date                   who                   Reference              
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM 
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES

*---------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_REDO.B.LY.GET.TXN.M.COMMON

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*----
INIT:
*----
*-------------------------------------------------------------------------
* This section initialises necessary local common variables
*-------------------------------------------------------------------------

    MODALITY.CCY.LIST = ''
    MODALITY.ID.LIST = ''
    MODALITY.APP.TXN.LIST = ''
    MODALITY.TXN.CODE.LIST = ''
    MODALITY.GEN.FACT.LIST = ''
    MODALITY.FORM.GEN.LIST = ''
    MODALITY.PROD.TYPE.LIST = ''
    MODALITY.PROD.LIST = ''
    MODALITY.CHANNEL.LIST = ''
    MODALITY.MINDISAMT.LIST = ''
    MODALITY.GEN.AMT.LIST = ''
    PROGRAM.EXCCONDTYPE.ESP.LIST = ''
    PROGRAM.APPEXC.LIST = ''
    PROGRAM.EXCCONDTYPE.LIST = ''
    PROGRAM.INCCONDTYPE.ESP.LIST = ''
    PROGRAM.APPINC.LIST = ''
    PROGRAM.INCCONDTYPE.LIST = ''

    LOC.REF.POS = ''
    LOC.REF.APP = 'ACCOUNT':@FM:'FT.TXN.TYPE.CONDITION'
    LOC.REF.FIELD = 'L.AC.STATUS1':@VM:'L.AC.STATUS2':@FM:'L.FTTC.CHANNELS'
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)
    POS.L.AC.STATUS1 = LOC.REF.POS<1,1>
    POS.L.AC.STATUS2 = LOC.REF.POS<1,2>
    POS.L.FTTC.CHANNELS = LOC.REF.POS<2,1>

RETURN

*----------
OPEN.FILES:
*----------

    FN.ACCT.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    F.ACCT.ENT.TODAY = ''
    CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

*    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'        ;*FOR TESTING LIKE SERVICE
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$HIS'      ;*FOR COB PROCESSING
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL = ''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.REDO.LY.TXN.BY.MOD = 'F.REDO.LY.TXN.BY.MOD'
    F.REDO.LY.TXN.BY.MOD = ''

*  OPEN FN.REDO.LY.TXN.BY.MOD TO F.REDO.LY.TXN.BY.MOD THEN NULL ;*Tus Start
    F.REDO.LY.TXN.BY.MOD = ''
    CALL OPF(FN.REDO.LY.TXN.BY.MOD,F.REDO.LY.TXN.BY.MOD) ;*Tus End

    FN.TEMP.LY.GET.TXN.M = 'F.TEMP.LY.GET.TXN.M'
    F.TEMP.LY.GET.TXN.M = ''

*  OPEN FN.TEMP.LY.GET.TXN.M TO F.TEMP.LY.GET.TXN.M THEN NULL ;*Tus Start
    F.TEMP.LY.GET.TXN.M = ''
    CALL OPF(FN.TEMP.LY.GET.TXN.M,F.TEMP.LY.GET.TXN.M) ;*Tus End

RETURN

*-------
PROCESS:
*-------
*--------------------------------------------------------------------------
* This section load read all params from F.TEMP.LY.GET.TXN.M
*--------------------------------------------------------------------------


*  READ PROGRAM.EXCCONDTYPE.ESP.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY1' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY1',PROGRAM.EXCCONDTYPE.ESP.LIST,F.TEMP.LY.GET.TXN.M,PROGRAM.EXCCONDTYPE.ESP.LIST.ERR)
    IF PROGRAM.EXCCONDTYPE.ESP.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ PROGRAM.APPEXC.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY2' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY2',PROGRAM.APPEXC.LIST,F.TEMP.LY.GET.TXN.M,PROGRAM.APPEXC.LIST.ERR)
    IF PROGRAM.APPEXC.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ PROGRAM.EXCCONDTYPE.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY3' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY3',PROGRAM.EXCCONDTYPE.LIST,F.TEMP.LY.GET.TXN.M,PROGRAM.EXCCONDTYPE.LIST.ERR)
    IF PROGRAM.EXCCONDTYPE.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ PROGRAM.INCCONDTYPE.ESP.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY4' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY4',PROGRAM.INCCONDTYPE.ESP.LIST,F.TEMP.LY.GET.TXN.M,PROGRAM.INCCONDTYPE.ESP.LIST.ERR)
    IF PROGRAM.INCCONDTYPE.ESP.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ PROGRAM.APPINC.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY5' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY5',PROGRAM.APPINC.LIST,F.TEMP.LY.GET.TXN.M,PROGRAM.APPINC.LIST.ERR)
    IF PROGRAM.APPINC.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END

*  READ PROGRAM.INCCONDTYPE.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY6' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY6',PROGRAM.INCCONDTYPE.LIST,F.TEMP.LY.GET.TXN.M,PROGRAM.INCCONDTYPE.LIST.ERR)
    IF PROGRAM.INCCONDTYPE.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.CCY.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY7' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY7',MODALITY.CCY.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.CCY.LIST.ERR)
    IF MODALITY.CCY.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.ID.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY8' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY8',MODALITY.ID.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.ID.LIST.ERR)
    IF MODALITY.ID.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.APP.TXN.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY9' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY9',MODALITY.APP.TXN.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.APP.TXN.LIST.ERR)
    IF MODALITY.APP.TXN.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.TXN.CODE.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY10' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY10',MODALITY.TXN.CODE.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.TXN.CODE.LIST.ERR)
    IF MODALITY.TXN.CODE.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.FORM.GEN.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY11' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY11',MODALITY.FORM.GEN.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.FORM.GEN.LIST.ERR)
    IF MODALITY.FORM.GEN.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.CHANNEL.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY12' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY12',MODALITY.CHANNEL.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.CHANNEL.LIST.ERR)
    IF MODALITY.CHANNEL.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.MINDISAMT.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY13' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY13',MODALITY.MINDISAMT.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.MINDISAMT.LIST.ERR)
    IF MODALITY.MINDISAMT.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.GEN.AMT.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY14' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY14',MODALITY.GEN.AMT.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.GEN.AMT.LIST.ERR)
    IF MODALITY.GEN.AMT.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.PROD.TYPE.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY15' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY15',MODALITY.PROD.TYPE.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.PROD.TYPE.LIST.ERR)
    IF MODALITY.PROD.TYPE.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.PROD.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY16' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY16',MODALITY.PROD.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.PROD.LIST.ERR)
    IF MODALITY.PROD.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END


*  READ MODALITY.GEN.FACT.LIST FROM F.TEMP.LY.GET.TXN.M,'VARLY17' ELSE ;*Tus Start
    CALL F.READ(FN.TEMP.LY.GET.TXN.M,'VARLY17',MODALITY.GEN.FACT.LIST,F.TEMP.LY.GET.TXN.M,MODALITY.GEN.FACT.LIST.ERR)
    IF MODALITY.GEN.FACT.LIST.ERR THEN  ;* Tus End
        GOSUB READ.ERROR
    END

RETURN

*----------
READ.ERROR:
*----------

    CRT 'Error to Reading in the Record'

RETURN

END
