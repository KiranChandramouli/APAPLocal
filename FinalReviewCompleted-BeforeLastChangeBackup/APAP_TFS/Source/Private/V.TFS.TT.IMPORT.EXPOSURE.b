* @ValidationCode : MjotMTgwODA4ODY3ODpDcDEyNTI6MTY5ODc1MDY3NDg1MzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>119</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE V.TFS.TT.IMPORT.EXPOSURE
*
* Subroutine Type : VERSION
* Attached to     : TELLER,T24.FS
* Attached as     : FIELD.VALIDATION Routine to DEALER.DESK field
* Primary Purpose : Populate EXP.ACCT and EXPOSURE.CCY fields
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 29 AUG 07 - Sathish PS
*             TFS Exposure development as part of Entry Netting
*
* 09 SEO 07 - Sathish PS
*             Incorrect E being passed even if PROCESS.GOAHEAD = 0
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion            GLOBUS.BP File Removed, FM TO @FM
*-----------------------------------------------------------------------------------
    $INCLUDE I_COMMON ;*R22 Manual Conversion - START
    $INCLUDE I_EQUATE

    $INCLUDE I_GTS.COMMON
    $INCLUDE I_F.TELLER
    $INCLUDE I_F.ACCOUNT ;*R22 Manual Conversion - END

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:

    R.NEW(TT.TE.EXPOSURE.CCY) = EXP.CCY
    R.NEW(TT.TE.EXP.ACCT)<1,1> = EXP.AC
    R.NEW(TT.TE.EXP.SPT.DAT)<1,1> = R.NEW(TT.TE.LOCAL.REF)<1,EXP.DAT.POS>
    R.NEW(TT.TE.EXP.SPT.AMT)<1,1> = R.NEW(TT.TE.LOCAL.REF)<1,EXP.AMT.POS>

RETURN          ;* from PROCESS
*-----------------------------------------------------------------------------------
* <New Subroutines>

* </New Subroutines>
*-----------------------------------------------------------------------------------*
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:

    PROCESS.GOAHEAD = 1

RETURN          ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:

    FN.AC = 'F.ACCOUNT' ; F.AC = ''

RETURN          ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*
    LOOP.CNT = 1 ; MAX.LOOPS = 3
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
                TT.LREF.NAMES = 'TFS.EXP.ACCT' :@FM: 'TFS.EXP.CCY' ;*R22 Manual Conversion
                TT.LREF.NAMES := @FM: 'TFS.EXP.DAT' :@FM: 'TFS.EXP.AMT'
                CALL GET.LOC.REF.CACHE('TELLER',TT.LREF.NAMES,TT.LREF.POSNS,TT.LREF.ERR)
                IF TT.LREF.ERR THEN
                    E = RAISE(TT.LREF.ERR<1>)
                    PROCESS.GOAHEAD = 0
                END ELSE
                    EXP.AC.POS = TT.LREF.POSNS<1>
                    EXP.CCY.POS = TT.LREF.POSNS<2>
                    EXP.DAT.POS = TT.LREF.POSNS<3>
                    EXP.AMT.POS = TT.LREF.POSNS<4>
                END

            CASE LOOP.CNT EQ 2
                EXP.AC = R.NEW(TT.TE.LOCAL.REF)<1,EXP.AC.POS>
                !            EXP.CCY = R.NEW(TT.TE.LOCAL.REF)<1,EXP.CCY.POS> ;* 09 SEP 07 - Sathish PS s/e
                IF NOT(EXP.AC) THEN PROCESS.GOAHEAD = 0

            CASE LOOP.CNT EQ 3    ;* 09 SEP 07 - Sathish PS s/e
                EXP.CCY = R.NEW(TT.TE.LOCAL.REF)<1,EXP.CCY.POS> ;* 09 SEP 07 - Sathish PS s/e
                IF NOT(EXP.CCY) THEN
                    CALL F.READ(FN.AC,EXP.AC,R.EXP.AC,F.AC,ERR.AC)
                    IF R.EXP.AC THEN
                        EXP.CCY = R.EXP.AC<AC.CURRENCY>
                    END ELSE
                        E = 'EB-US.REC.MISS.FILE'
                        E<2,1> = EXP.AC
                        E<2,2> = FN.AC
                        PROCESS.GOAHEAD = 0
                    END
                END

            CASE LOOP.CNT EQ 3
REM > CU.LREF.NAMES = 'SIGNATURE.Y.N' :FM: 'US.TAX.ID' :FM: 'US.TAX.ID.TYP'
REM > CU.LREF.POSNS = '' ; CU.LREF.ERR = ''
REM > CALL GET.LOC.REF.CACHE("CUSTOMER",CU.LREF.NAMES,CU.LREF.POSNS,CU.LREF.ERR)
REM > IF CU.LREF.ERR THEN
REM >   ETEXT = RAISE(CU.LREF.ERR<1>)
REM >   PROCESS.GOAHEAD = 0
REM > END ELSE
REM >   SIGN.POS = CU.LREF.POSNS<1> ; TAX.ID.POS = CU.LREF.POSNS<2> ; TAX.ID.TYP.POS = CU.LREF.POSNS<3>
REM > END

        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN          ;* From CHECK.PRELIM.CONDITIONS
*-----------------------------------------------------------------------------------
END






