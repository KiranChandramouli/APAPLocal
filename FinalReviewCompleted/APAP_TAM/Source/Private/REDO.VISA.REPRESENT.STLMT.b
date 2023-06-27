* @ValidationCode : Mjo1NTg5NjU2Njg6Q3AxMjUyOjE2ODQ4NDIxNTE1MTI6SVRTUzotMTotMToxODY6MTpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 186
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VISA.REPRESENT.STLMT
*----------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.REPRESENT.STLMT
*Date              : 23.11.2010

*Description:
*----------------
*This routine is to represent the charge back raised
*This need to raise an outgoing message with TC.CODE 05,06,07 and USAGE.CODE as 2 in message
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
** 19-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 19-04-2023 Skanda R22 Manual Conversion - No changes , CALL routine format modified
*------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.VISA.OUTGOING


    GOSUB OPEN.FILE
    GOSUB PROCESS


RETURN

OPEN.FILE:
    FN.REDO.VISA.GEN.OUT='F.REDO.VISA.GEN.OUT'
    F.REDO.VISA.GEN.OUT=''
    CALL OPF(FN.REDO.VISA.GEN.OUT,F.REDO.VISA.GEN.OUT)

RETURN
*-----------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------
    Y.OLD.ID.NEW=ID.NEW
    MATBUILD R.REDO.OUTGOING FROM R.NEW

    BEGIN CASE
        CASE R.NEW(VISA.SETTLE.TRANSACTION.CODE) EQ 15
            TC.CODE.ALT='05'
        CASE R.NEW(VISA.SETTLE.TRANSACTION.CODE) EQ 16
            TC.CODE.ALT='06'
        CASE R.NEW(VISA.SETTLE.TRANSACTION.CODE) EQ 17
            TC.CODE.ALT='07'
    END CASE

    R.REDO.OUTGOING<VISA.OUT.TRANSACTION.CODE>=TC.CODE.ALT
    R.REDO.OUTGOING<VISA.OUT.FINAL.STATUS>=''
    R.REDO.OUTGOING<VISA.OUT.STATUS>='VERIFYINFO'
    R.REDO.OUTGOING<VISA.OUT.USAGE.CODE>=2

    Y.ID.COMPANY=ID.COMPANY
    CALL LOAD.COMPANY(Y.ID.COMPANY)
    FULL.FNAME = 'F.REDO.VISA.OUTGOING'
    ID.T  = 'A'
    ID.N ='15'
    ID.CONCATFILE = ''
    COMI = ''
    PGM.TYPE = '.IDA'
    ID.NEW = ''
    V$FUNCTION = 'I'
    ID.NEW.LAST=''
    ID.NEWLAST = ID.NEW.LAST
    CALL GET.NEXT.ID(ID.NEWLAST,'F')
    ID.NEW.LAST=ID.NEWLAST


    Y.ID= COMI

    OTHR.TCR.ARR=R.REDO.OUTGOING<VISA.OUT.OTHER.TCR.LINE>

    Y.OTHR.TCR.ARR.CNT=DCOUNT(OTHR.TCR.ARR,@VM)
    VAR2=1
    LOOP
    WHILE VAR2 LE Y.OTHR.TCR.ARR.CNT
        OTHR.TCR.ARR<1,VAR2>[1,2]=TC.CODE.ALT
        VAR2 += 1 ;* R22 Auto conversion
    REPEAT

    R.REDO.OUTGOING<VISA.OUT.OTHER.TCR.LINE>=OTHR.TCR.ARR

    R.NEW(VISA.SETTLE.CHARGEBACK.REF.NO)=Y.ID

    APAP.TAM.redoVisaOutgoingWrite(Y.ID,R.REDO.OUTGOING) ;*MANUAL R22 CODE CONVERSION
    
    GEN.OUT.ID=Y.ID:'*REDO.VISA.OUTGOING'
    CALL F.WRITE(FN.REDO.VISA.GEN.OUT,GEN.OUT.ID,'')

    ID.NEW=Y.OLD.ID.NEW
RETURN
END
