*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CAMPAIGN.CREATE.SELECT
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep P
* Program Name  : REDO.APAP.CAMPAIGN.CREATE.SELECT
* ODR NUMBER    : ODR-2010-08-0228
*--------------------------------------------------------------------------------
* Description : This is a .select routine to select the required records
* In parameter : None
* out parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO          REFERENCE         DESCRIPTION
* 25-08-2010     Pradeep P    ODR-2010-08-0228    Initial Creation
* ----------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CR.OPPORTUNITY
$INSERT I_REDO.APAP.CAMPAIGN.CREATE.COMMON

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*
INIT:
*-----
  SEL.CMD = ''
  SEL.LIST = ''
  NO.OF.RECS = ''
  SEL.ERR = ''
  RETURN
*
PROCESS:
*-------

  SEL.CMD = "SELECT ":FN.CR.OPP:" WITH OPPOR.DEF.ID EQ ":Y.DAT
  CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
  IF SEL.LIST EQ '' THEN
    INT.CODE = 'CTI001'
    INT.TYPE = 'BATCH'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = Y.DAT
    MON.TP   = '03'
    DESC     = 'No Records found for Campaign ':Y.DAT
    REC.CON  = ''
    EX.USER  = ''
    EX.PC    = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
  END
  CALL BATCH.BUILD.LIST("",SEL.LIST)
  RETURN
END
