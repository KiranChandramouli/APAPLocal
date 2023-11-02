* @ValidationCode : Mjo5MTk4ODgyMjM6Q3AxMjUyOjE2OTg3NTA2NzQ4MTA6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
* <Rating>216</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE V.TFS.TT.IMPORT.DENOM
*
* Field validation subroutine attached to UNIT and DR.UNIT fields in TELLER to
* import the data from the local ref fields, passed in by T24.FUND.SERVICES
*
*---------------------------------------------------------------------------------
* Modification History:
*
* 03/25/05 - Sathish PS
*            New Development
*
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion           GLOBUS.BP File Removed, FM TO @FM
*---------------------------------------------------------------------------------
    $INCLUDE I_COMMON ;*R22 Manual Conversion
    $INCLUDE I_EQUATE ;*R22 Manual Conversion
    $INCLUDE I_F.TELLER ;*R22 Manual Conversion

    GOSUB INIT
    GOSUB PRELIM.CONDS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*----------------------------------------------------------------------------------
PROCESS:

* First for the Units
    GOSUB GET.CREDIT.DENOM.DETAILS
    IF IMPORT.DENOM.ARR THEN GOSUB IMPORT.DENOMINATIONS
* Now,for the DR Units
    GOSUB GET.DEBIT.DENOM.DETAILS
    IF IMPORT.DENOM.ARR THEN GOSUB IMPORT.DENOMINATIONS

RETURN
*----------------------------------------------------------------------------------
GET.CREDIT.DENOM.DETAILS:

    IMPORT.DENOM.ARR = '' ; IMPORT.UNIT.ARR = '' ; IMPORT.SERIAL.ARR = ''
    IMPORT.DENOM.ARR = R.NEW(TT.TE.LOCAL.REF)<1,CR.DEN.POS>
    IMPORT.UNIT.ARR = R.NEW(TT.TE.LOCAL.REF)<1,CR.UNIT.POS>
    IMPORT.SERIAL.ARR = R.NEW(TT.TE.LOCAL.REF)<1,CR.SER.POS>
    TELLER.DENOM.FIELD = TT.TE.DENOMINATION
    TELLER.DENOM.UNIT.FIELD = TT.TE.UNIT
    TELLER.SERIAL.FIELD = TT.TE.SERIAL.NO

RETURN
*----------------------------------------------------------------------------------
GET.DEBIT.DENOM.DETAILS:

    IMPORT.DENOM.ARR = '' ; IMPORT.UNIT.ARR = '' ; IMPORT.SERIAL.ARR = ''
    IMPORT.DENOM.ARR = R.NEW(TT.TE.LOCAL.REF)<1,DR.DEN.POS>
    IMPORT.UNIT.ARR = R.NEW(TT.TE.LOCAL.REF)<1,DR.UNIT.POS>
    IMPORT.SERIAL.ARR = R.NEW(TT.TE.LOCAL.REF)<1,DR.SER.POS>
    TELLER.DENOM.FIELD = TT.TE.DR.DENOM
    TELLER.DENOM.UNIT.FIELD = TT.TE.DR.UNIT
    TELLER.SERIAL.FIELD = TT.TE.DR.SERIAL.NO


RETURN
*----------------------------------------------------------------------------------
IMPORT.DENOMINATIONS:

    R.NEW(TELLER.DENOM.FIELD) = RAISE(IMPORT.DENOM.ARR)
    R.NEW(TELLER.DENOM.UNIT.FIELD) = RAISE(IMPORT.UNIT.ARR)
    R.NEW(TELLER.SERIAL.FIELD) = RAISE(IMPORT.SERIAL.ARR)

RETURN
*----------------------------------------------------------------------------------
*/////////////////////////////////////////////////////////////////////////////////*
*//////////////// P R E  P R O C E S S  S U B R O U T I N E S ////////////////////*
*/////////////////////////////////////////////////////////////////////////////////*
INIT:

    PROCESS.GOAHEAD = 1
*
    IMPORT.DENOM = ''
    IMPORT.UNIT = ''
    IMPORT.SERIAL = ''
    TELLER.DENOM.FIELD = ''
    TELLER.SERIAL.FIELD = ''
*
    TT.LREF.NAMES = 'TFS.CR.DENOM' :@FM: 'TFS.CR.UNIT' :@FM: 'TFS.CR.SERIAL' ;*R22 Manual Conversion
    TT.LREF.NAMES := @FM: 'TFS.DR.DENOM' :@FM: 'TFS.DR.UNIT' :@FM: 'TFS.DR.SERIAL'
    TT.LREF.POSNS = '' ; TT.LREF.ERR = ''
    CALL GET.LOC.REF.CACHE("TELLER",TT.LREF.NAMES,TT.LREF.POSNS,TT.LREF.ERR)
    IF TT.LREF.ERR THEN
        ETEXT = RAISE(TT.LREF.ERR<1>)
        PROCESS.GOAHEAD = 0
    END ELSE
        CR.DEN.POS = TT.LREF.POSNS<1> ; CR.UNIT.POS = TT.LREF.POSNS<2> ; CR.SER.POS = TT.LREF.POSNS<3>
        DR.DEN.POS = TT.LREF.POSNS<4> ; DR.UNIT.POS = TT.LREF.POSNS<5> ; DR.SER.POS = TT.LREF.POSNS<6>
    END

RETURN
*----------------------------------------------------------------------------------
PRELIM.CONDS:

    IF NOT(R.NEW(TT.TE.LOCAL.REF)<1,CR.DEN.POS>) AND NOT(R.NEW(TT.TE.LOCAL.REF)<1,DR.DEN.POS>) THEN
        PROCESS.GOAHEAD = 0
    END
*
    IF AV GT 1 THEN PROCESS.GOAHEAD = 0 ;* Only for the first time
*

RETURN
*----------------------------------------------------------------------------------
END


