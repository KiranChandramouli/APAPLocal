*-----------------------------------------------------------------------------
* <Rating>-54</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CAPL.B.BUILD.LINE.CONT.SELECT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPL.B.BUILD.LINE.CONT.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Batch .SELECT routine, this batch routine takes backup of the record from
*                    the file RE.STAT.LINE.CONT inorder to extract the back dated reports from the system
*Linked With       : Batch BNK/RE.BUILD.SLC
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER      As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 21 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.GL.H.EXTRACT.PARAMETER
$INSERT I_REDO.CAPL.B.BUILD.LINE.CONT.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

  REDO.GL.H.EXTRACT.PARAMETER.ID = 'SYSTEM'
  GOSUB READ.REDO.GL.H.EXTRACT.PARAMETER

  Y.TOTAL.REPORTS=R.REDO.GL.H.EXTRACT.PARAMETER<SAP.EP.REPORT.NAME>
  CHANGE SM TO VM IN Y.TOTAL.REPORTS
  Y.REP.COUNT = DCOUNT(Y.TOTAL.REPORTS,VM)
  Y.REP.START = 1

  LOOP
  WHILE Y.REP.START LE Y.REP.COUNT
    LOCATE Y.TOTAL.REPORTS<1,Y.REP.START> IN Y.REP.LIST SETTING Y.REP.POS THEN
      Y.REP.START += 1
      CONTINUE
    END

    Y.REP.LIST<-1> = Y.TOTAL.REPORTS<1,Y.REP.START>
    IF NOT(SEL.CMD) THEN
      SEL.CMD = 'SELECT ':FN.RE.STAT.LINE.CONT:' WITH TYPE EQ DETAIL AND (@ID LIKE ':Y.TOTAL.REPORTS<1,Y.REP.START>:'...'
    END ELSE
      SEL.CMD := ' OR WITH @ID LIKE ':Y.TOTAL.REPORTS<1,Y.REP.START>:'...'
    END
    Y.REP.START += 1
  REPEAT
  SEL.CMD := ") AND (ASST.CONSOL.KEY NE '' OR ASSET.TYPE NE '' OR PROFIT.CCY NE '' OR PRFT.CONSOL.KEY NE '')"

  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST)

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
