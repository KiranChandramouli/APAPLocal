* @ValidationCode : MjotNzQ3ODQzMzY2OkNwMTI1MjoxNjg0ODQyMTUyNTI0OklUU1M6LTE6LTE6ODE6MTpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 81
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.B.CUSTOMER.SYNC.SELECT
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.30.2013
* Description  : Routine for sychronizing customers with Vision Plus
* Type         : Batch Routine
* Attached to  : BATCH > BNK/REDO.VP.CUST.SYNC.SERVICE
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
* 2.0       2-sep-2015     Prabhu                           modified to multi thread
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       CALL ROUTINE FORMAT MODIFIED
*------------------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_REDO.VP.B.CUSTOMER.SYNC.COMMON
    $USING APAP.REDOSRTN

    GOSUB PROCESS

RETURN

***********************
PROCESS:
***********************
*CALL APAP.TAM.REDO.S.NOTIFY.INTERFACE.ACT('VPL006', 'BATCH', '06', 'EMAIL SINCRONIZACION DE CLIENTES', 'INICIO - SINCRONIZACION DE CLIENTES A LAS ' : TIMEDATE(), '','', '', '', '', OPERATOR, '')     ;*R22 MANUAL CODE CONVERSION
    CALL APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL006', 'BATCH', '06', 'EMAIL SINCRONIZACION DE CLIENTES', 'INICIO - SINCRONIZACION DE CLIENTES A LAS ' : TIMEDATE(), '','', '', '', '', OPERATOR, '')     ;*R22 MANUAL CODE CONVERSION
    READ Y.MSG FROM Y.PTR,CS.FILE THEN
        CALL BATCH.BUILD.LIST('',Y.MSG)
    END
    ELSE
        LOG.MESSAGE = 'ERROR: Archivo no encontrado: ' : CS.FILE
        Y.LOG.IND = 'Y'
        GOSUB ERROR.LOG
    END
RETURN
*---------
ERROR.LOG:
*---------
    IF Y.LOG.IND THEN
        Y.ERR.LOG = ' [CON ERRORES] '
    END ELSE
        Y.ERR.LOG = ' '
    END

    LOG.FILE.NAME = 'CS' : PROCESS.DATE : '.log'
    Y.CS.PATH     =CS.PATH
    CALL APAP.TAM.redoVpUtilLog(LOG.FILE.NAME, CS.PATH, LOG.MESSAGE)    ;*R22 MANUAL CODE CONVERSION

    CALL APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL006', 'BATCH', '07', 'EMAIL SINCRONIZACION DE CLIENTES', 'FIN' : Y.ERR.LOG : '- SINCRONIZACION DE CLIENTES A LAS ' : TIMEDATE() : ' - LOG EN ' : CS.PATH : '\' : LOG.FILE.NAME, '', '', '', '', '', OPERATOR, '')     ;*R22 MANUAL CODE CONVERSION

RETURN
END
