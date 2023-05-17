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

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_REDO.VP.B.CUSTOMER.SYNC.COMMON

    GOSUB PROCESS

RETURN

***********************
PROCESS:
***********************
    CALL REDO.S.NOTIFY.INTERFACE.ACT ('VPL006', 'BATCH', '06', 'EMAIL SINCRONIZACION DE CLIENTES', 'INICIO - SINCRONIZACION DE CLIENTES A LAS ' : TIMEDATE(), '','', '', '', '', OPERATOR, '')
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
    CALL REDO.VP.UTIL.LOG(LOG.FILE.NAME, CS.PATH, LOG.MESSAGE)

    CALL REDO.S.NOTIFY.INTERFACE.ACT ('VPL006', 'BATCH', '07', 'EMAIL SINCRONIZACION DE CLIENTES', 'FIN' : Y.ERR.LOG : '- SINCRONIZACION DE CLIENTES A LAS ' : TIMEDATE() : ' - LOG EN ' : CS.PATH : '\' : LOG.FILE.NAME, '', '', '', '', '', OPERATOR, '')

RETURN
END
