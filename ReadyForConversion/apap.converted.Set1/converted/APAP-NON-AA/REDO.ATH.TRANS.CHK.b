SUBROUTINE REDO.ATH.TRANS.CHK
************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : H GANESH
* Program Name : REDO.ATH.IN.FMT.AMOUNT
*****************************************************************
*Description: This routine is to format the transaction amount
*******************************************************************************
*In parameter : None
*Out parameter : None
****************************************************************************
*Modification History:
**************************
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   5-01-2011       H Ganesh              ODR-2010-08-0469         Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.ATH.STLMT.FILE.PROCESS.COMMON



    GOSUB PROCESS
RETURN


PROCESS:

    IF Y.FIELD.VALUE EQ '30' THEN
        CONT.FLAG = 'TRUE'
    END

RETURN
END
