* @ValidationCode : MjoxMjI2MDI0Mzg5OkNwMTI1MjoxNjgxODI5MDgzNDg3OklUU1M6LTE6LTE6LTIwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -20
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------
SUBROUTINE REDO.COL.EXTRACT.PRE.SELECT
*-----------------------------------------------------------------------------
* REDO COLLECTOR EXTRACT PRE-Process Load routine
* Service : REDO.COL.EXTRACT.PRE
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
* 14/09/2011 - PACS00110378         En lugar de leer toda la CUSTOMER.ACCOUNT leer los prestamos
*                                   para mejorar el Performance y extraer los ID de clientes
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.COL.EXTRACT.PRE.COMMON
    $INSERT I_F.DATES
*-----------------------------------------------------------------------------
    LIST.PARAMETERS = '' ; ID.LIST = ''

    IF NOT(C.ALREADY.PROCESSED) THEN      ;* This is first time that th process is executed
        GOSUB CRITERIA.VALUE
        LIST.PARAMETERS<2> = 'F.AA.ARRANGEMENT'
        LIST.PARAMETERS<3> = CRITERIA
        CALL OCOMO("Deleting F.REDO.MSG.COL.QUEUE content")
        CALL EB.CLEAR.FILE(FN.REDO.COL.MSG.QUEUE, F.REDO.COL.MSG.QUEUE)
    END ELSE
        CALL OCOMO("Atention!!!!")
        CALL OCOMO("-------------")
        CALL OCOMO("Process was already executing, this an re-execution process ")
    END

    CALL OCOMO("Deleting F.REDO.COL.QUEUE content")
    CALL EB.CLEAR.FILE(FN.REDO.COL.QUEUE, F.REDO.COL.QUEUE)

*
    GOSUB DELETE.ERROR.TRACE    ;* Just delete ERROR from trace
*

    CALL OCOMO("Deleting F.REDO.COL.QUEUE.ERROR content")
    CALL EB.CLEAR.FILE(FN.REDO.COL.QUEUE.ERROR, F.REDO.COL.QUEUE.ERROR)
*
    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)

RETURN
*-------------------------------------------------------------
* Create the list of Elements to process
DELETE.ERROR.TRACE:
*-------------------------------------------------------------
    NUM.TABLE=0
    NUM.TABLE = DCOUNT(C.TABLE.PROCESS,@VM)
    SELECT.STMT=''
    FOR I.VAR=1 TO NUM.TABLE

        SELECT.STMT :=' OR TABLE EQ ':C.TABLE.PROCESS<1,I.VAR>

    NEXT I.VAR

    FILE.NAME = FN.REDO.COL.TRACE
    FILE.NAME<2> = " WITH @ID LIKE " : TODAY : ".... ":SELECT.STMT
    CALL EB.CLEAR.FILE(FILE.NAME, F.REDO.COL.TRACE)


RETURN
*-------------------------------------------------------------
CRITERIA.VALUE:
*-------------------------------------------------------------

    NUM.PRODUCT =DCOUNT(C.AA.PRODUCT.GROUP<1>,@VM)
    NUM.STATUS  =DCOUNT(C.AA.STATUS<1>,@VM)
    CRITERIA    ='ARR.STATUS EQ '
    FOR I.VAR=1 TO NUM.STATUS
        CRITERIA   :=C.AA.STATUS<1,I.VAR>:' '
    NEXT I.VAR

    CRITERIA   :='AND PRODUCT.GROUP EQ '

    FOR I.VAR=1 TO NUM.PRODUCT
        CRITERIA   :=C.AA.PRODUCT.GROUP<1,I.VAR>:' '
    NEXT I.VAR

    CRITERIA   :='AND START.DATE LE ':R.DATES(EB.DAT.LAST.WORKING.DAY):' CUSTOMER'

RETURN
END
