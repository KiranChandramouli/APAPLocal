* @ValidationCode : Mjo2OTk5NzMzODE6Q3AxMjUyOjE2ODExOTA1MzgwNTE6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:52:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.GARNISH.DETAILS.RECORD
*-------------------------------------------------------------------------
*DIS:is the record routine will default the @ID value in the field GARNISHMENT.REF
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : BHARATH C
* Program Name  : REDO.V.INP.GARNISHMENT.MAINT
* ODR NUMBER    : ODR-2009-10-0531
*----------------------------------------------------------------------
*Input param = none
*output param =none
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*--------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.GARNISH.DETAILS

    GOSUB INIT
*GOSUB OPENFILE
    GOSUB PROCESS
RETURN
*---------------------
INIT:
    GARNISHMENT.ID=''
RETURN
*-------------------
OPENFILE:
    FN.GARNISHMENT='F.APAP.H.GARNISH.DETAILS$NAU'
    F.GARNISHMENT =''
    CALL OPF(FN.GARNISHMENT,F.GARNISHMENT)
RETURN
*--------------------
PROCESS:
    GARNISHMENT.ID=ID.NEW
    R.NEW(APAP.GAR.GARNISHMENT.REF)=GARNISHMENT.ID

    IF R.OLD(APAP.GAR.IDENTITY.TYPE) EQ '' AND R.NEW(APAP.GAR.IDENTITY.NUMBER) EQ '' THEN
        R.NEW(APAP.GAR.RECEP.DATE) = TODAY  ;* Field to store the date on which garnishment has happened.
    END

RETURN
*---------------------

END
