SUBROUTINE REDO.BLD.PRINT.REPRINT.SLIP(ENQ.DATA)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.BLD.PRINT.REPRINT.SLIP
*-------------------------------------------------------------------------
* Description: This Build routine is used to genearate to view the printing/reprinting deal slip
*----------------------------------------------------------
* Linked with: REDO.ENQ.PRINT.REPRINT.SLIP
* In parameter : ENQ.DATA
* out parameter : ENQ.DATA
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*03-05-2011       Sudharsanan S          PACS00055008      Initial Creation
****************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*---------
OPENFILES:
*----------

    FN.REDO.PRINT.REPRINT.IDS = 'F.REDO.PRINT.REPRINT.IDS'
    F.REDO.PRINT.REPRINT.IDS = ''
    CALL OPF(FN.REDO.PRINT.REPRINT.IDS,F.REDO.PRINT.REPRINT.IDS)

RETURN

*------------
PROCESS:
*------------
    Y.CONTRACT.NO = ENQ.DATA<4,1>
    R.REDO.PRINT.REPRINT.IDS = '' ; PRINT.ERR = ''
    BEGIN CASE
        CASE Y.CONTRACT.NO[1,2] EQ 'FT'
            CALL F.READ(FN.REDO.PRINT.REPRINT.IDS,'FT',R.REDO.PRINT.REPRINT.IDS,F.REDO.PRINT.REPRINT.IDS,PRINT.ERR)
            GOSUB GET.HOLD.ID
        CASE Y.CONTRACT.NO[1,2] EQ 'TT'
            CALL F.READ(FN.REDO.PRINT.REPRINT.IDS,'TT',R.REDO.PRINT.REPRINT.IDS,F.REDO.PRINT.REPRINT.IDS,PRINT.ERR)
            GOSUB GET.HOLD.ID
        CASE Y.CONTRACT.NO[1,5] EQ 'T24FS'
            CALL F.READ(FN.REDO.PRINT.REPRINT.IDS,'T24FS',R.REDO.PRINT.REPRINT.IDS,F.REDO.PRINT.REPRINT.IDS,PRINT.ERR)
            GOSUB GET.HOLD.ID
    END CASE
    IF VAR.HOLD.ID THEN
        ENQ.DATA<4,1> = VAR.HOLD.ID
    END
RETURN
*******************
GET.HOLD.ID:
*******************
    IF R.REDO.PRINT.REPRINT.IDS THEN
        Y.CONTRACT.ID = FIELDS(R.REDO.PRINT.REPRINT.IDS,"*",1,1)
        LOCATE Y.CONTRACT.NO IN Y.CONTRACT.ID SETTING POS THEN
            Y.HOLD.ID  = R.REDO.PRINT.REPRINT.IDS<POS>
            VAR.HOLD.ID = FIELD(Y.HOLD.ID,"*",2)
            CHANGE "," TO " " IN VAR.HOLD.ID  ;* PACS00245671 S/E
        END ELSE
            ENQ.ERROR = 'EB-REPRINT.TRANS.ID.NOT.FOUND'
        END
    END ELSE
        ENQ.ERROR = 'EB-REPRINT.TRANS.ID.NOT.FOUND'
    END
RETURN
**************************************
END
