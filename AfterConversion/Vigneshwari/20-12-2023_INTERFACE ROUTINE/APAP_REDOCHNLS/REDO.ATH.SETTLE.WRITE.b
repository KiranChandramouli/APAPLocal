* @ValidationCode : MjoxNTIwMTE4NTU1OkNwMTI1MjoxNzAzMDc2MjM5NzM2OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Dec 2023 18:13:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
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
*
* 11-APR-2023     Conversion tool    R22 Auto conversion       VM to @VM, ++ to +=, TNO to C$T24.SESSION.NO
* 11-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*20-12-2023	   VIGNESHWARI    ADDED COMMENT FOR INTERFACE CHANGES          ATM- By Santiago
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
        CONV.CNT = DCOUNT(R.REDO.ATH.STLMT.MAPPING<ATH.STL.MAP.FIELD.NAME>,@VM)	;*Fix ATM- By Santiago-CHANGE "VM" TO "@VM"
        II = 0
        LOOP
            II++	;*Fix ATM- By Santiago-CHANGE "II += 1" TO "II++"
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
  R.ARRAY<ATH.SETT.INPUTTER>=TNO:'_':OPERATOR	;*Fix ATM- By Santiago-change"C$T24.SESSION.NO" to "TNO"
  R.ARRAY<ATH.SETT.AUTHORISER>=TNO:'_':OPERATOR	;*Fix ATM- By Santiago-change"C$T24.SESSION.NO" to "TNO"
  R.ARRAY<ATH.SETT.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
  R.ARRAY<ATH.SETT.CO.CODE>=ID.COMPANY
  CALL F.WRITE(FN.REDO.ATH.SETTLMENT,Y.ID,R.ARRAY)


  RETURN

END
