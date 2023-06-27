* @ValidationCode : MjotMTM4NTg2NTI1NzpDcDEyNTI6MTY4NDg0MjA5MzQ3NTpJVFNTOi0xOi0xOi00MzoxOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -43
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose :
*                   Validate of Mandatory field according COLLATERAL.CODE
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
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 08 Junio 2011
* Modify by       : JP
* Date Modify     : 05 Agosto 2011
** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT


    GOSUB INITIALISE
    GOSUB PROCESS.MESSAGE

RETURN


*-----------------------------------------------------------------------------
INITIALISE:
***
    Y.ERROR.MESSAGE = ''

RETURN
*-----------------------------------------------------------------------------
PROCESS.MESSAGE:

    BEGIN CASE
        CASE MESSAGE EQ ''          ;* Only during commit
            BEGIN CASE
                CASE V$FUNCTION EQ 'D'
*GOSUB VALIDATE.DELETE
                CASE V$FUNCTION EQ 'R'
                    GOSUB VALIDATE.REVERSE
                CASE OTHERWISE  ;* The real VALIDATE
                    GOSUB VALIDATE
            END CASE
        CASE MESSAGE EQ 'AUT'       ;* During authorisation and verification
* Si no funciona las validaciones del validate
            IF V$FUNCTION EQ 'R' THEN
*GOSUB VALIDATE.REVERSE
            END

    END CASE

*
RETURN
*-----------------------------------------------------------------------------
VALIDATE:
*---------------------------------------------------------------------------
* LANZA VALIDACIONES DINAMICAS DE COLLATERALS SEGUN PARAMETRIZACION PARA LA VERSION
*

*CALL REDO.FC.S.VALID.COLL
    APAP.TAM.redoFcSValidColl() ;*R22 Manual Conversion

RETURN
*-----------------------------------------------------------------------------
VALIDATE.REVERSE:
*---------------------------------------------------------------------------
* Proceso de validacion antes de reversar los registros creados en:
* Polizas, Coll.right, Coll y Limit
*

    IF R.NEW(REDO.FC.STATUS.TEMPLATE) EQ "INPROGRESS" THEN
* ----> Aqui la llamada a la rutina de validacion llamada REDO.FC.S.VALREV

        CALL REDO.FC.REV.VAL

    END ELSE

        ETEXT = "EB-REVERSAL.NOT.ALLOWED"
        CALL STORE.END.ERROR
    END
RETURN

*-----------------------------------------------------------------------------
END
