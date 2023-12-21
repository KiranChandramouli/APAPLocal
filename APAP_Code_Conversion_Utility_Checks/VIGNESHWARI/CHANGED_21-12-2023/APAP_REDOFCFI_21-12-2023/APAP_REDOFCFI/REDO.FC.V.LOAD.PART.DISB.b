* @ValidationCode : Mjo4ODgzMDIyMjQ6Q3AxMjUyOjE3MDI2NDQ2Mjg1NDY6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Dec 2023 18:20:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.V.LOAD.PART.DISB

*
* Subroutine Type : Validation
* Attached to     : REDO.AA.PART.DISBURSE.FC,PART.DISB
* Attached as     : ROUTINE
* Primary Purpose : Read and load values from REDO.FC.FORM.DISB in order to display them on screen version
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
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : TAM
* Date            : 28-11-2012
* PACS00236823
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           I TO I.VAR
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*15-12-2023          VIGNESHWARI S                      MANUAL R22 CODE CONVERSION            OPF IS ADDED
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
    $INSERT I_F.REDO.FC.FORM.DISB
    $INSERT I_F.REDO.FC.INST.DISB
    $INSERT I_GTS.COMMON

* ------------------------------------------------------------------------------------------
    CAMPO.ACTUAL = OFS$HOT.FIELD
    NOMBRE.CAMPO = "...DIS.TYPE..."
    IF CAMPO.ACTUAL MATCH NOMBRE.CAMPO ELSE
        RETURN
    END
*-------------------

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    ID.FORM.DISB = COMI
    CALL CACHE.READ(FN.REDO.FC.FORM.DISB,ID.FORM.DISB,R.REDO.FC.FORM.DISB,YERR)
    IF R.REDO.FC.FORM.DISB THEN
        NRO.CONT = DCOUNT(R.REDO.FC.FORM.DISB<FC.PR.ID.INST.DISB>,@VM)
        R.NEW(REDO.PDIS.ID.DET.INS)<1,AV>= ""
        R.NEW(REDO.PDIS.FIELD.DET.INS)<1,AV>= ""
        R.NEW(REDO.PDIS.VAL.DET.INS)<1,AV>= ""
        I.VAR = ''
        LOOP
        WHILE NRO.CONT GT 0 DO
            I.VAR += 1
            ID.INST.DISB = R.REDO.FC.FORM.DISB<FC.PR.ID.INST.DISB,I.VAR>
            CALL F.READ(FN.REDO.FC.INST.DISB,ID.INST.DISB,R.REDO.FC.INST.DISB,F.REDO.FC.INST.DISB,YERR)
            INST.DESCP = R.REDO.FC.INST.DISB<FC.PR.DESCRIPCION>
            R.NEW(REDO.PDIS.ID.DET.INS)<1,AV,I.VAR>= ID.INST.DISB
            R.NEW(REDO.PDIS.FIELD.DET.INS)<1,AV,I.VAR>= INST.DESCP
            NRO.CONT -= 1
        REPEAT
    END
RETURN
*------------------------
INITIALISE:
*=========
    FN.REDO.FC.FORM.DISB = 'F.REDO.FC.FORM.DISB'
    F.REDO.FC.FORM.DISB =''
    R.REDO.FC.FORM.DISB = ''
    CALL OPF(FN.REDO.FC.FORM.DISB,F.REDO.FC.FORM.DISB)

    FN.REDO.FC.INST.DISB = 'F.REDO.FC.INST.DISB'
    F.REDO.FC.INST.DISB = ''
    CALL OPF(FN.REDO.FC.INST.DISB,F.REDO.FC.INST.DISB)

    R.REDO.FC.INST.DISB = ''

    PROCESS.GOAHEAD = 1
RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
