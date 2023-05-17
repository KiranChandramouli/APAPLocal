SUBROUTINE REDO.VP.B.CUSTOMER.SYNC(Y.LINE)
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
* 2.0       2-sep-2015     Prabhu                           modified to multi thread:updates the field L.CU.TARJ.CR in customer
*
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_REDO.VP.B.CUSTOMER.SYNC.COMMON

* </region>

    GOSUB PROCESS

RETURN

***********************
PROCESS:
***********************
    CUSTOMER.ID  = Y.LINE[',',1,1]
    CARD.STATUS  = Y.LINE[',',2,1]

    CALL F.READ(FN.CUSTOMER, CUSTOMER.ID, R.CUSTOMER, F.CUSTOMER, Y.ERR)
    IF NOT(R.CUSTOMER) THEN
        LOG.MESSAGE = 'ERROR: Cliente [' : CUSTOMER.ID : '] no existe'
        Y.LOG.IND = 'Y'
        GOSUB ERROR.LOG
    END ELSE
        GOSUB CHECK.STATUS
    END

RETURN

***************
CHECK.STATUS:
***************
* Change Card status
    NEW.CARD.STATUS = ''

    IF CARD.STATUS EQ 'Y' THEN
        NEW.CARD.STATUS = 'YES'
    END ELSE
        IF CARD.STATUS EQ 'N' THEN
            NEW.CARD.STATUS = 'NO'
        END
    END

    IF NEW.CARD.STATUS THEN
        IF R.CUSTOMER<EB.CUS.LOCAL.REF, CU.TARJ.CR.POS> NE NEW.CARD.STATUS THEN
            R.CUSTOMER<EB.CUS.LOCAL.REF, CU.TARJ.CR.POS> = NEW.CARD.STATUS
            CALL F.WRITE(FN.CUSTOMER, CUSTOMER.ID, R.CUSTOMER)
        END
    END ELSE
        LOG.MESSAGE = 'ERROR: Para el cliente ' : CUSTOMER.ID : ' el estado ' : CARD.STATUS : ' no es correcto'
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

    LOG.FILE.NAME = 'CS' : PROCESS.DATE:'.temp':AGENT.NUMBER
    Y.CS.PATH     =  CS.PATH

    OPENSEQ Y.CS.PATH,LOG.FILE.NAME TO Y.FILE.PATH ELSE
        CREATE Y.FILE.PATH ELSE
            CALL OCOMO("CANNOT OPEN SESSION FILE PATH")
        END
    END
    WRITESEQ LOG.MESSAGE APPEND TO Y.FILE.PATH ELSE
        CALL OCOMO("CANNOT WRITE TO SESSION FILE OF ID ":LOG.FILE.NAME)
    END
RETURN
END
