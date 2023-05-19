*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ATH.SETTLE.WRITE(Y.ID,R.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.ATH.SETTLE.WRITE
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is write the REDO.ATH.SETTLE.WRITE with Audit Fields



*IN PARAMETER: R.ARRAY
*OUT PARAMETER: NA
*LINKED WITH: ATH.SETTLEMENT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*1.12.2010  H GANESH     ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.USER
$INSERT I_F.REDO.ATH.SETTLMENT
$INSERT I_F.REDO.ATH.STLMT.MAPPING


  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------



  FN.REDO.ATH.SETTLMENT='F.REDO.ATH.SETTLMENT'
  F.REDO.ATH.SETTLMENT=''
  CALL OPF(FN.REDO.ATH.SETTLMENT,F.REDO.ATH.SETTLMENT)
  
* PACS00577318 -S
    FN.REDO.ATH.STLMT.MAPPING = 'F.REDO.ATH.STLMT.MAPPING'
    F.REDO.ATH.STLMT.MAPPING  = ''
    CALL OPF(FN.REDO.ATH.STLMT.MAPPING,F.REDO.ATH.STLMT.MAPPING)

    CALL CACHE.READ(FN.REDO.ATH.STLMT.MAPPING,'CONV',R.REDO.ATH.STLMT.MAPPING,PARAM.ERR)
    IF R.REDO.ATH.STLMT.MAPPING<ATH.STL.MAP.FIELD.NAME> THEN
        Y.IN.APPLICATION = 'REDO.ATH.SETTLMENT' ; R.SS.APPLICATION = ''
        CALL GET.STANDARD.SELECTION.DETS(Y.IN.APPLICATION,R.SS.APPLICATION)
        CONV.CNT = DCOUNT(R.REDO.ATH.STLMT.MAPPING<ATH.STL.MAP.FIELD.NAME>,VM)
        II = 0
        LOOP
            II++
        WHILE II LE CONV.CNT
            FLD.NAME = R.REDO.ATH.STLMT.MAPPING<ATH.STL.MAP.FIELD.NAME,II>
            YAF = '' ; YAV = '' ; YAS = '' ; DATA.TYPE = '' ; ERR.MSG = '' ; FIELD.NO = ''
            CALL FIELD.NAMES.TO.NUMBERS(FLD.NAME,R.SS.APPLICATION,FIELD.NO,YAF,YAV,YAS,DATA.TYPE,ERR.MSG)
            R.ARRAY<FIELD.NO> = UTF8(R.ARRAY<FIELD.NO>)
        REPEAT
    END
* PACS00577318 -e

  TEMPTIME = OCONV(TIME(),"MTS")
  TEMPTIME = TEMPTIME[1,5]
  CHANGE ':' TO '' IN TEMPTIME
  CHECK.DATE = DATE()
  R.ARRAY<ATH.SETT.RECORD.STATUS>=''
  R.ARRAY<ATH.SETT.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):FMT(OCONV(CHECK.DATE,"DD"),"R%2"):TEMPTIME
  R.ARRAY<ATH.SETT.CURR.NO>=R.ARRAY<ATH.SETT.CURR.NO>+1
  R.ARRAY<ATH.SETT.INPUTTER>=TNO:'_':OPERATOR
  R.ARRAY<ATH.SETT.AUTHORISER>=TNO:'_':OPERATOR
  R.ARRAY<ATH.SETT.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
  R.ARRAY<ATH.SETT.CO.CODE>=ID.COMPANY
  CALL F.WRITE(FN.REDO.ATH.SETTLMENT,Y.ID,R.ARRAY)


  RETURN

END