* @ValidationCode : MjoxNjE5MDM0ODU3OkNwMTI1MjoxNjgwOTQwNzExNjE5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Apr 2023 13:28:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
* Version 2 02/06/00 GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.PRINT.DEAL.SLIP.VALIDATE
*-----------------------------------------------------------------------------
*** Template FOR validation routines                   ;** R22 Auto conversion - ! TO *
* @author youremail@temenos.com
* @stereotype validator
* @package infra.eb
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - ! TO *
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

* 07/06/06 - BG_100011433
* Creation
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_F.REDO.PRINT.DEAL.SLIP
    $INSERT I_RC.COMMON
    GOSUB INITIALISE
    GOSUB PROCESS.MESSAGE
RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:

    ID.NEW = R.NEW(RE.PRIN.CUSTOMER.NO)

    CALL F.READ(FN.CUSTOMER,ID.NEW,R.CUST,F.CUSTOMER,CUS.ERR)
    IF R.CUST THEN
        TYPE.OF.CUSTOMER = R.CUST<EB.CUS.LOCAL.REF><1,TIPO.POS>
    END

    OFS$DEAL.SLIP.PRINTING = 1

    IF TYPE.OF.CUSTOMER EQ 'PERSONA FISICA' THEN

        CALL PRODUCE.DEAL.SLIP("CUS.KYC.FORM.1")

    END
    IF TYPE.OF.CUSTOMER EQ 'PERSONA JURIDICA' THEN

        CALL PRODUCE.DEAL.SLIP("CUS.KYC.FORM.2")

    END
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
***
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',TIPO.POS)

RETURN
*-----------------------------------------------------------------------------
PROCESS.MESSAGE:
    BEGIN CASE
        CASE MESSAGE EQ '' ;* Only during commit
            BEGIN CASE
                CASE V$FUNCTION EQ 'D'
                    GOSUB VALIDATE.DELETE
                CASE V$FUNCTION EQ 'R'
                    GOSUB VALIDATE.REVERSE
                CASE OTHERWISE ;* The real VALIDATE
                    GOSUB VALIDATE
            END CASE
        CASE MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER' ;* During authorisation and verification
            GOSUB VALIDATE.AUTHORISATION
    END CASE
RETURN
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.DELETE>
VALIDATE.DELETE:
* Any special checks for deletion

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.REVERSE>
VALIDATE.REVERSE:
* Any special checks for reversal

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.AUTHORISATION>
VALIDATE.AUTHORISATION:
* Any special checks for authorisation

RETURN
*** </region>
*-----------------------------------------------------------------------------
END
