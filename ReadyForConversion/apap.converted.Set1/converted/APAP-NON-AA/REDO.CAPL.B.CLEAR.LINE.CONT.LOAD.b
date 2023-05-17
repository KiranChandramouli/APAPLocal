SUBROUTINE REDO.CAPL.B.CLEAR.LINE.CONT.LOAD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPL.B.CLEAR.LINE.CONT.LOAD
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Batch .LOAD routine, this batch routine clears the backup taken from
*                    the file RE.STAT.LINE.CONT inorder to extract the back dated reports from the system
*Linked With       : Batch BNK/RE.BUILD.SLC
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER      As              I               Mode
*                    REDO.CAPL.L.RE.STAT.LINE.CONT    As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 26 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
    $INSERT I_F.REDO.CAPL.L.RE.STAT.LINE.CONT
    $INSERT I_REDO.CAPL.B.CLEAR.LINE.CONT.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.REDO.GL.H.EXTRACT.PARAMETER = 'F.REDO.GL.H.EXTRACT.PARAMETER'
    F.REDO.GL.H.EXTRACT.PARAMETER = ''
    CALL OPF(FN.REDO.GL.H.EXTRACT.PARAMETER,F.REDO.GL.H.EXTRACT.PARAMETER)

    FN.REDO.CAPL.L.RE.STAT.LINE.CONT = 'F.REDO.CAPL.L.RE.STAT.LINE.CONT'
    F.REDO.CAPL.L.RE.STAT.LINE.CONT = ''
    CALL OPF(FN.REDO.CAPL.L.RE.STAT.LINE.CONT,F.REDO.CAPL.L.RE.STAT.LINE.CONT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    REDO.GL.H.EXTRACT.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.GL.H.EXTRACT.PARAMETER

RETURN
*--------------------------------------------------------------------------------------------------------
*********************************
READ.REDO.GL.H.EXTRACT.PARAMETER:
*********************************
* In this para of the code, file REDO.GL.H.EXTRACT.PARAMETER is read
    R.REDO.GL.H.EXTRACT.PARAMETER  = ''
    REDO.GL.H.EXTRACT.PARAMETER.ER = ''
    CALL CACHE.READ(FN.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ID,R.REDO.GL.H.EXTRACT.PARAMETER,REDO.GL.H.EXTRACT.PARAMETER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
