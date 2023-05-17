SUBROUTINE REDO.DS.CHK.CPY(Y.TRANS.ID)
**********************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE
*---------------------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.DS.CHK.CPY
*----------------------------------------------------------------------------------------------
* Description : This is a conversion routine which gets the value of Transaction number
**********************************************************************************************
*Linked With :
*In parameter :
*Out parameter :
********************************************************************************************


    GOSUB INIT
    GOSUB PROCESS

RETURN

****
INIT:
*****

    FN.REDO.APAP.H.DEAL.SLIP.QUEUE = 'F.REDO.APAP.H.DEAL.SLIP.QUEUE'
    F.REDO.APAP.H.DEAL.SLIP.QUEUE  = ''
    CALL OPF(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,F.REDO.APAP.H.DEAL.SLIP.QUEUE)

RETURN


********
PROCESS:
*********

    CALL F.READ(FN.REDO.APAP.H.DEAL.SLIP.QUEUE,Y.TRANS.ID,R.REDO.APAP.H.DEAL.SLIP.QUEUE,F.REDO.APAP.H.DEAL.SLIP.QUEUE,QUEUE.ERR)

    Y.PRINT = R.REDO.APAP.H.DEAL.SLIP.QUEUE<REDO.DS.QUEUE.INIT.PRINT>


    IF Y.PRINT EQ 'YES' THEN
        Y.TRANS.ID = 'COPIA'
    END ELSE
        Y.TRANS.ID = ''
    END

RETURN
****************************************************************************************************
END
