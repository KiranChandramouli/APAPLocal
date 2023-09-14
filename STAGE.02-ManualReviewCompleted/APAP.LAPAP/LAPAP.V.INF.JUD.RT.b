* @ValidationCode : Mjo0OTc3NzQ2NDA6Q3AxMjUyOjE2ODIwNzA5MjA5NzU6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:25:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.V.INF.JUD.RT
*-------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.COMPANY     ;*R22 AUTO CODE CONVERSION.END

*MSG = ''
*MSG<-1> = 'Llamo rutina'
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

    GOSUB DO.INITIALIZE
    IF R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) NE 'RNC' THEN
        IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
            GOSUB GET.CON.JUD
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------
* Pgm. Name: LAPAP.V.INF.JUD.RT
* Desc.: This subroutine is attached as an embedded validation-input routine for REDO.ID.CARD.CHECK, version.
* By: J.Q.
* On: Sep 23 2022
*-----------------------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------------------
DO.INITIALIZE:
    Y.COMPANY.NAME = R.COMPANY(EB.COM.COMPANY.NAME)
    Y.COMPANY.NAME.FMT = Y.COMPANY.NAME
    CHANGE ' ' TO '.' IN Y.COMPANY.NAME.FMT
    Y.OPERATOR = OPERATOR
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------
GET.CON.JUD:
    V.EB.API.ID = 'LAPAP.CONJUDICIAL.ITF'
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*C::CEDULA::USUARIO::SUCURSAL::SUCURSAL
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Y.IDENTIFICATION = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
    Y.PARAMETRO.ENVIO = 'C::' : Y.IDENTIFICATION : '::' : Y.OPERATOR : '::' : Y.COMPANY.NAME.FMT : '::' : Y.COMPANY.NAME.FMT
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CALL EB.CALL.JAVA.API(V.EB.API.ID,Y.PARAMETRO.ENVIO,Y.RESPONSE,Y.CALLJ.ERROR)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    IF Y.RESPONSE THEN
        GOSUB DO.VALIDATE
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------
DO.VALIDATE:


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Y.DECISION = FIELD(Y.RESPONSE,'&',3)

    IF Y.DECISION EQ 'Si' THEN

        IF GETENV("JUDICIAL_INQUIRY_NOTIFY", shouldNotifyAssertion) THEN

            IF shouldNotifyAssertion EQ 'yes' THEN
                CALL LAPAP.PLAF.NOTIFY.RT("JUDICIAL")
            END
        END
        AF = 2
        AV = 1
        AS = 1
        TEXT = "No cumple con politicas internas."
        ETEXT = TEXT
*E = TEXT
        CALL STORE.END.ERROR
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------------------------
END
