* @ValidationCode : MjotMTQ4MTgxMzM3MTpDcDEyNTI6MTcwNDg4NjQxNDUzNjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Jan 2024 17:03:34
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.R.GET.LIMIT.PRODUCT(Y.APPLICATION, Y.CATEGORY, Y.PRODUCT)
*-----------------------------------------------------------------------------
* This routine is used to look for the LIMIT.PRODUCT to use according to CATEGROY code
* It is called from REDO.CREATE.ARRANGEMENT application
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package redo.fc
*
* IN
*                Y.APPLICATION    Application, must be ACCOUNT for REDO.CREATE.ARRANGEMENT
*                Y.CATEGORY        Category Code for AA contract
* OUT
*                Y.PRODUCT         LIMIT.REFERENCE gotten from LIMIT.PARAMETER table
*                E (common)        In case of Error this variable has the user's message
* NOTE:
*                The routine returns the last code that was found, this means, it omits duplicated AND it returns
*                the last code that is applicable FOR the category
** 13-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT.PARAMETER
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    IF Y.PRODUCT EQ "" THEN
        E = "ST-REDO.CRE.ARR.LIMIT.PRODUCT.NOT.FOUND" : @VM : "LIMIT PORODUCT NOT FOUND FOR CATEGORY &" : Y.CATEGORY
    END
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    YAV = 1
    Y.PRODUCT = ''
    Y.DEF.LIMIT = ''
    LOOP
        YAPPL = YR.SYSTEM<LI.PAR.APPLICATION,YAV>
    WHILE YAPPL DO
        IF Y.APPLICATION EQ YAPPL THEN
            IF YR.SYSTEM<LI.PAR.DECIS.FIELD,YAV> EQ '' THEN
                Y.DEF.LIMIT = YR.SYSTEM<LI.PAR.PRODUCT.NO, YAV, 1>
                YAV += 1 ;* R22 Auto conversion
                CONTINUE
            END
            IF YR.SYSTEM<LI.PAR.DECIS.FIELD, YAV, 1> NE 'CATEGORY' THEN
                CALL OCOMO("OMITING FIELD " : YR.SYSTEM<LI.PAR.DECIS.FIELD, YAV, 1> : " IN " : YAPPL )
                YAV += 1 ;* R22 Auto conversion
                CONTINUE
            END
            GOSUB GET.PRODUCT
        END
        YAV += 1 ;* R22 Auto conversion
    REPEAT

    IF Y.PRODUCT EQ "" AND Y.DEF.LIMIT NE '' THEN
        CALL OCOMO("Setting default Limit")
        Y.PRODUCT = Y.DEF.LIMIT
    END


RETURN
*-----------------------------------------------------------------------------
GET.PRODUCT:
*-----------------------------------------------------------------------------
    Y.DE.FR = YR.SYSTEM<LI.PAR.DECISION.FR, YAV,1>
    Y.DE.TO = YR.SYSTEM<LI.PAR.DECISION.TO, YAV,1>
    Y.OP    = YR.SYSTEM<LI.PAR.DECISION, YAV,1>
    IF Y.OP NE "EQ" THEN
        CALL OCOMO("OMITING OPERATOR DECISION " : Y.OP)
        RETURN
    END
    BEGIN CASE
* The ranges were input, then make a BETWEEN
        CASE Y.DE.FR NE "" AND Y.DE.TO NE ""
            IF Y.DE.FR GE Y.CATEGORY AND Y.DE.TO LE Y.CATEGORY THEN
                Y.PRODUCT = YR.SYSTEM<LI.PAR.PRODUCT.NO, YAV, 1>
            END
* only FROM range was input, then make a EQUALS
        CASE Y.DE.FR NE "" AND Y.DE.TO EQ ""
            IF Y.DE.FR EQ Y.CATEGORY THEN
                Y.PRODUCT = YR.SYSTEM<LI.PAR.PRODUCT.NO, YAV, 1>
            END
    END CASE
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    YR.SYSTEM = ''
*    CALL CACHE.READ("F.LIMIT.PARAMETER","SYSTEM",YR.SYSTEM,ER)
    FN.LIMIT.PARAMETER = "F.LIMIT.PARAMETER";* R22 UTILITY AUTO CONVERSION
*    CALL CACHE.READ(FN.LIMIT.PARAMETER,"SYSTEM",YR.SYSTEM,ER);* R22 UTILITY AUTO CONVERSION
    IDVAR.1 = "SYSTEM" ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.LIMIT.PARAMETER,IDVAR.1,YR.SYSTEM,ER);* R22 UTILITY AUTO CONVERSION;* R22 UTILITY AUTO CONVERSION
    IF ER THEN
        TEXT = "MISSING FILE=F.LIMIT.PARAMETER ID=SYSTEM"
        CALL FATAL.ERROR ("LIMIT.GET.PRODUCT")
    END

RETURN

END
