* @ValidationCode : MjotNTM5ODY5Njg4OkNwMTI1MjoxNjgxMjE1NDUwNDExOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 17:47:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CAMPAIGN.GEN.RUN
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep P
* Program Name  : REDO.APAP.CAMPAIGN.GEN.RUN
* ODR NUMBER    : ODR-2010-08-0228
*----------------------------------------------------------------------------------
* Description : This run routine is triggered to generate a .TXT file
* In parameter : None
* out parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO          REFERENCE         DESCRIPTION
* 25-08-2010     Pradeep P    ODR-2010-08-0228    Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.TSA.SERVICE
    $INSERT I_F.REDO.APAP.CAMPAIGN.GEN

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

INIT:
*----
    FN.REDO.APAP.CAM.GEN = 'F.REDO.APAP.CAMPAIGN.GEN'
    F.REDO.APAP.CAM.GEN = ''
    R.CAM.GEN.REC = ''
    Y.CAM.ERR = ''

    FN.BATCH = 'F.BATCH'
    F.BATCH = ''
    R.BATCH.REC = ''

    FN.TSA.SERVICE = 'F.TSA.SERVICE'
    F.TSA.SERVICE = ''
    R.TSA.REC = ''

RETURN
*
OPENFILES:
*---------
    CALL OPF(FN.REDO.APAP.CAM.GEN,F.REDO.APAP.CAM.GEN)
    CALL OPF(FN.BATCH,F.BATCH)
    CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)
RETURN
*
PROCESS:
*-------
    Y.CAMPAIGN.ID = R.NEW(REDO.CAMPGN.GEN.CAMPAIGN.ID)
    Y.BATCH.ID = "BNK/REDO.B.CAMPAIGN.FILE.GEN"
    Y.ID = ID.NEW
    CALL F.READ(FN.REDO.APAP.CAM.GEN,Y.ID,R.CAM.GEN.REC,F.REDO.APAP.CAM.GEN,Y.CAM.ERR)
    Y.CAM.ID  =   R.NEW(REDO.CAMPGN.GEN.CAMP.ID)

    Y.COUNT = DCOUNT(Y.CAM.ID,@VM)
    R.CAM.GEN.REC<REDO.CAMPGN.GEN.CAMP.ID,Y.COUNT+1> = Y.CAMPAIGN.ID
    R.CAM.GEN.REC<REDO.CAMPGN.GEN.USER.ID,Y.COUNT+1> = OPERATOR
    R.CAM.GEN.REC<REDO.CAMPGN.GEN.TIME,Y.COUNT+1> = TIMEDATE()[1,2]:TIMEDATE()[4,2]

    CALL F.WRITE(FN.REDO.APAP.CAM.GEN,Y.ID,R.CAM.GEN.REC)

    CALL F.READ(FN.BATCH,Y.BATCH.ID,R.BATCH.REC,F.BATCH,Y.B.ERR)

    R.BATCH.REC<BAT.DATA> = Y.CAMPAIGN.ID
    CALL F.WRITE(FN.BATCH,Y.BATCH.ID,R.BATCH.REC)
    SERVICE.ACTION = 'START'
    SERVICE.NAME = "BNK/REDO.B.CAMPAIGN.FILE.GEN"

    CALL SERVICE.CONTROL(SERVICE.NAME,SERVICE.ACTION,'')
    CALL JOURNAL.UPDATE(SERVICE.NAME)

    CALL F.READ(FN.TSA.SERVICE,"TSM",R.TSA.REC,F.TSA.SERVICE,Y.TSA.ERR)
    IF R.TSA.REC THEN
        Y.TSA.STATUS = R.TSA.REC<TS.TSM.SERVICE.CONTROL>
    END
    IF Y.TSA.STATUS EQ 'STOP' THEN
        INT.CODE = "CTI002"
        INT.TYPE = "ONLINE"
        BAT.NO = ''
        BAT.TOT = ''
        INFO.OR = ''
        INFO.DE = ''
        ID.PROC = 'TSM'
        MON.TP = '03'
        DESC = 'TSM is not STARTED'
        REC.CON = ''
        EX.USER = ''
        EX.PC = ''
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END
RETURN
END
