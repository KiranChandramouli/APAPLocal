* @ValidationCode : MjotMTY3ODY4OTg2MTpDcDEyNTI6MTY5ODc1MDY3NDQwNzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
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
* Version 2 02/06/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>544</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.PAR.CROSSVAL
*-----------------------------------------------------------------------
* Crossval subroutine for TFS.PARAMETER template
*
*-----------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development

*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion         VM TO @VM, SM TO @SM, Call Rtn Format Can be Modified
*
*
*-----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
*-----------------------------------------------------------------------
*
*
*-----------------------------------------------------------------------
*
    GOSUB INITIALISE
*
    GOSUB REPEAT.CHECK.FIELDS
*
    GOSUB REAL.CROSSVAL
*
RETURN
*
*-----------------------------------------------------------------------
*
REAL.CROSSVAL:
*
* Real cross validation goes here....
*
RETURN
*
*-----------------------------------------------------------------------
*
REPEAT.CHECK.FIELDS:
*
* Loop through each field and repeat the check field processing if there is any defined
*
    FOR AF = 1 TO V-9
        IF INDEX(N(AF), "C", 1) THEN
*
* Is it a sub value, a multi value or just a field
*
            BEGIN CASE
                CASE F(AF)[4,2] EQ 'XX'      ;* Sv
                    NO.OF.AV = DCOUNT(R.NEW(AF), @VM) ;*R22 Manual Conversion
                    IF NO.OF.AV = 0 THEN NO.OF.AV = 1
                    FOR AV = 1 TO NO.OF.AV
                        NO.OF.SV = DCOUNT(R.NEW(AF)<1,AV>, @SM) ;*R22 Manual Conversion
                        IF NO.OF.SV = 0 THEN NO.OF.SV = 1
                        FOR AS = 1 TO NO.OF.SV
                            GOSUB DO.CHECK.FIELD
                        NEXT AS
                    NEXT AV
                CASE F(AF)[1,2] EQ 'XX'      ;* Mv
                    AS = ''
                    NO.OF.AV = DCOUNT(R.NEW(AF), @VM)
                    IF NO.OF.AV = 0 THEN NO.OF.AV = 1
                    FOR AV = 1 TO NO.OF.AV
                        GOSUB DO.CHECK.FIELD
                    NEXT AV
                CASE OTHERWISE
                    AV = '' ; AS = ''
                    GOSUB DO.CHECK.FIELD
            END CASE
        END
    NEXT AF
RETURN
*
*-----------------------------------------------------------------------
*
DO.CHECK.FIELD:
** Repeat the check field validation - errors are returned in the
** variable E.
*
    COMI.ENRI = ""
    BEGIN CASE
        CASE AS
            COMI = R.NEW(AF)<1,AV,AS>
        CASE AV
            COMI = R.NEW(AF)<1,AV>
        CASE AF
            COMI = R.NEW(AF)
    END CASE
*
* CALL TFS.PAR.CHECK.FIELDS
    APAP.TFS.tfsParCheckFields() ;*R22 Manual Code Conversion
    IF E THEN
        ETEXT = E
        CALL STORE.END.ERROR
    END ELSE
        BEGIN CASE
            CASE AS
                R.NEW(AF)<1,AV,AS> = COMI
                YENRI.FLD = AF:".":AV:".":AS ; YENRI = COMI.ENRI
                GOSUB SET.UP.ENRI
            CASE AV
                R.NEW(AF)<1,AV> = COMI
                YENRI.FLD = AF:".":AV ; YENRI = COMI.ENRI
                GOSUB SET.UP.ENRI
            CASE AF
                R.NEW(AF) = COMI
                YENRI.FLD = AF ; YENRI = COMI.ENRI
                GOSUB SET.UP.ENRI
        END CASE
    END
RETURN
*
*-----------------------------------------------------------------------
*
SET.UP.ENRI:
*
    LOCATE YENRI.FLD IN T.FIELDNO<1> SETTING YPOS THEN
*         T.ENRI<YPOS> = YENRI
    END
RETURN
*
*-----------------------------------------------------------------------
*
INITIALISE:
*
RETURN
*
*-----------------------------------------------------------------------
*
END
