*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.ATH.INITIAL.PROCESS.SELECT
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.ATH.INITIAL.PROCESS.SELECT
*Date              : 06.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*06/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ATH.STLMT.FILE.DETAILS
$INSERT I_F.REDO.ATH.PROCESS.INFO
$INSERT I_REDO.ATH.INITIAL.PROCESS.COMMON


  GOSUB READING
  GOSUB PROCESS

  RETURN

*------------------------------------------------------------------------------------
READING:
*------------------------------------------------------------------------------------
!READING F.REDO.ATH.STLMT.FILE.DETAILS APPLICATION WITH ID AS 'SYSTEM'
  FILES.NAME=''
  REDO.ID='SYSTEM'
  CALL CACHE.READ(FN.REDO.ATH.STLMT.FILE.DETAILS,REDO.ID,R.REDO.ATH.STLMT.FILE.DETAILS,REDO.ERR)
  Y.FILE.NAME=R.REDO.ATH.STLMT.FILE.DETAILS<ATH.STMT.FILE.FILE.NAME>
  Y.FILE.PATH=R.REDO.ATH.STLMT.FILE.DETAILS<ATH.STMT.FILE.FILE.PATH>

  RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

  CHANGE VM TO '' IN Y.FILE.PATH

  SEL.FILE="SELECT ":Y.FILE.PATH:" WITH @ID LIKE ":Y.FILE.NAME:"..."
  CALL EB.READLIST(SEL.FILE,FILE.LIST,'',FILE.SEL,FILE.ERR)
  Y.FILENAME.LEN=LEN(Y.FILE.NAME)
  LOOP
    REMOVE FILE.NAME FROM FILE.LIST SETTING FILE.POS
  WHILE FILE.NAME:FILE.POS

    DATE.NAME=FILE.NAME[Y.FILENAME.LEN+2,8]
    COMI=DATE.NAME
    CALL IN2D("12","D")
    FLAG.FAIL=0
    IF ETEXT THEN
      CALL OCOMO(DATE.NAME : " IS NOT A VALID FILE NAME IN FILE " : FILE.NAME )

      REC.CON ='INVALID FILE NAME'
      DESC    = 'INVALID FILE NAME'
      GOSUB LOG.ERROR.C22

      PATH.BCK=BATCH.DETAILS<3,1,1>

      MOVE.CMD="mv " : Y.FILE.PATH:"/":FILE.NAME : " " :PATH.BCK : "/BCK." : FILE.NAME
      EXECUTE MOVE.CMD
      FLAG.FAIL=1
    END

    IF FILE.NAME[Y.FILENAME.LEN+2,8] LE TODAY AND FLAG.FAIL NE 1 THEN


      FILES.NAME<-1>=FILE.NAME:"*":Y.FILE.PATH
    END
  REPEAT
  CALL BATCH.BUILD.LIST('',FILES.NAME)

  RETURN

*-----------------------------------------------------------------------------
LOG.ERROR.C22:
*-----------------------------------------------------------------------------
  MON.TP='04'
  INT.CODE = 'ATH001'
  INT.TYPE = 'BATCH'
  BAT.NO = ''
  BAT.TOT = ''
  INFO.OR = ''
  INFO.DE = ''
  ID.PROC = ''
  EX.USER = ''
  EX.PC = ''
  CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
  RETURN
END
