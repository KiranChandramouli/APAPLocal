* @ValidationCode : MjotMTE4ODA4NDQ2MjpDcDEyNTI6MTY4MTE5Nzc5Mzc2MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 12:53:13
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
SUBROUTINE REDO.H.REVALUATION.PARAM.VALIDATE

* Validation routine for the template US.GAAP.REVALUATION.PARAMETER
* @author kswathi@temenos.com
* @stereotype fields
* @uses C_METHODS
* @uses C_PROPERTIES
* @package infra.eb
*-----------------------------------------------------------------------------
* Revision History:
*------------------
* Date               who           Reference            Description
* 21/05/2009       SWATHI K                            Initial Version.
*-----------------------------------------------------------------------------
* Modification History :
* dd/mm/yyy    - CD_REFERENCE - author
*              Description of modification. Why, what and who.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.REVALUATION.PARAM

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
*Initialising the variables

    Y.PRODUCT.CATEGORY = ''
    PROD.CATEG = ''
    Y.PL.CATEGORY = ''
    PL.CATEG = ''
    Y.REV.PL.CATEGORY = ''

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*Main process

    IF MESSAGE EQ '' THEN
        GOSUB VAL.REV.PL.CATEG.RANGE
        GOSUB VAL.PRODUCT.RANGE
    END

RETURN
*------------------------------------------------------------------------------
VAL.PRODUCT.RANGE:
*------------------------------------------------------------------------------
*Checking the PRODUCT.CATEG to be less than 49999 and PL.CATEGORY
*to be greater than 51999.
*If it fails to match the criteria then an error is thrown.

* Validation for Start.Range
    START.RANGE.ARRAY = ''
    POS1 = ''
    START.VAL = ''
    CNT = 0

    IF R.NEW(REVAL.PARM.PL.START.PRD.RANGE) NE '' THEN

        START.RANGE.ARRAY = R.NEW(REVAL.PARM.PL.START.PRD.RANGE)

        CNT += 1
        LOOP
            REMOVE START.VAL FROM START.RANGE.ARRAY SETTING POS1
        WHILE START.VAL:POS1
            IF START.VAL GE '49999' THEN
                AF = REVAL.PARM.PL.START.PRD.RANGE
                AV = CNT
                ETEXT = 'EB-PRODUCT.RANGE'
                CALL STORE.END.ERROR
            END

*ETEXT = 'EB-CATEG.RANGE'
        REPEAT
    END

* Validation for End.Range

    END.RANGE.ARRAY = ''
    END.POS = ''

    IF R.NEW(REVAL.PARM.PL.END.PRD.RANGE) NE '' THEN
        END.RANGE.ARRAY = R.NEW(REVAL.PARM.PL.END.PRD.RANGE)

        CNT = 0
        LOOP
            CNT +=1
            REMOVE END.VAL FROM END.RANGE.ARRAY SETTING END.POS
        WHILE END.VAL:END.POS
            IF END.VAL GE '49999' THEN
                AF = REVAL.PARM.PL.END.PRD.RANGE
                AV = CNT
                ETEXT = 'EB-PRODUCT.RANGE'
                CALL STORE.END.ERROR
            END
        REPEAT
    END

* Validation for PL.CATEGORY

    PL.CATEG.ARRAY = ''
    PL.POS = ''
    PL.VALUE = ''
    CNT = 0

    IF R.NEW(REVAL.PARM.PL.CATEGORY) NE '' THEN
        PL.CATEG.ARRAY = R.NEW(REVAL.PARM.PL.CATEGORY)
        LOOP
            CNT += 1
            REMOVE PL.VALUE FROM PL.CATEG.ARRAY SETTING PL.POS
        WHILE PL.POS:PL.VALUE
            IF PL.VALUE LE '51999' THEN
                AF = REVAL.PARM.PL.CATEGORY
                AV = CNT
                ETEXT = 'EB-CATEG.RANGE'
                CALL STORE.END.ERROR
                RETURN
            END

        REPEAT
    END
RETURN
*---------------------------------------------------------------------------------
VAL.REV.PL.CATEG.RANGE:
*---------------------------------------------------------------------------------
*Checking the REVERSE.PL.CATEG to be greater than 51999.
*If it fails to match the criteria then an error is thrown.

    Y.REV.PL.CATEGORY.ARRAY = R.NEW(REVAL.PARM.REV.PL.CATEGORY)
    CNT = 0
    PL.POS= ''

    LOOP
        CNT += 1
        REMOVE Y.REV.PL.CATEGORY FROM Y.REV.PL.CATEGORY.ARRAY SETTING PL.POS
    WHILE PL.POS:Y.REV.PL.CATEGORY
        IF Y.REV.PL.CATEGORY LE '51999' THEN
            AF = REVAL.PARM.REV.PL.CATEGORY
            AV = CNT
            ETEXT = 'EB-CATEG.RANGE'
            CALL STORE.END.ERROR
            RETURN
        END

    REPEAT



RETURN
*---------------------------------------------------------------------------------
END
