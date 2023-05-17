SUBROUTINE REDO.B.CLEAR.OUT.SELECT

*****************************************************************************************
*----------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS.
* Developed By  : Arulprakasam P
* Program Name  : REDO.B.CLEAR.OUT.SELECT
****-----------------------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
****------------------------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              REFERENCE            DESCRIPTION
* 23.11.2010        ODR-2010-09-0251     INITIAL CREATION
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CLEAR.OUT.COMMON

    SEL.CMD = "SELECT ":VAR.FILE.PATH
    CALL EB.READLIST(SEL.CMD,FILE.LIST,'',NO.OF.REC,RET.ERR)

    IF FILE.LIST THEN
        CALL BATCH.BUILD.LIST('',FILE.LIST)
    END ELSE
        INT.CODE ='APA002'
        INT.TYPE ='BATCH'
        BAT.NO =''
        BAT.TOT =''
        INFO.OR =''
        INFO.DE =''
        ID.PROC = FILE.LIST
        MON.TP ='03'
        DESC = RET.ERR
        Y.REC.CON = ''
        EX.USER = ''
        EX.PC = ''
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,Y.REC.CON,EX.USER,EX.PC)
    END

RETURN
*------------------------------------------------------------------------------------------
END
