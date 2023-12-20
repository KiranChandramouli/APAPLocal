* @ValidationCode : MjoxOTc3MjkxMjY6Q3AxMjUyOjE3MDI5NjM5ODk5MzY6MzMzc3U6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:03:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.RIEN5.EXT.OUT2
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 18/03/2015        Ashokkumar.V.P            PACS00309203 - Removed the concat file update.
* 27/03/2015        Ashokkumar.V.P            PACS00309203 - Performance change
*-------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023       Suresh                      R22 Manual Conversion      Change Hardcoding the value to IDVAR

*----------------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.RIEN5.PARAM
    $INSERT I_F.DR.REG.RIEN5.REP2
*
    GOSUB OPEN.FILES
    GOSUB WRITE.HEADER
    GOSUB PROCESS.PARA
RETURN

OPEN.FILES:
***********
    FN.DR.REG.RIEN5.PARAM = 'F.DR.REG.RIEN5.PARAM'
    F.DR.REG.RIEN5.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN5.PARAM,F.DR.REG.RIEN5.PARAM)

    FN.DR.REG.RIEN5.REP2 = 'F.DR.REG.RIEN5.REP2'
    F.DR.REG.RIEN5.REP2 = ''
    CALL OPF(FN.DR.REG.RIEN5.REP2,F.DR.REG.RIEN5.REP2)

    GOSUB INIT.BAL
    CURR.BAL1 = ''; CURR.BAL2 = ''; CURR.BAL3 = ''; CURR.BAL4 = ''; CURR.BAL5 = ''
    CURR.BAL6 = ''; CURR.BAL7 = ''; CURR.BAL8 = ''; CURR.BAL9 = ''; CURR.BAL10 = ''
    CURR.BAL11 = ''; CURR.INDET.BAL = ''
RETURN

WRITE.HEADER:
*************
    R.DR.REG.RIEN5.PARAM = ''; DR.REG.RIEN5.PARAM.ERR = ''
    IDVAR='SYSTEM' ;*R22 Manual Conversion
    CALL CACHE.READ(FN.DR.REG.RIEN5.PARAM,IDVAR,R.DR.REG.RIEN5.PARAM,DR.REG.RIEN5.PARAM.ERR) ;*R22 Manual Conversion
    FN.CHK.DIR = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.OUT.PATH>
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
*
    Y.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    EXTRACT.FILE.ID = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.FILE.NAME>:'_':R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.REP.NAME,2>:'_':Y.DATE:'.csv'
*
    R.FILE.DATA = ''
    REP.HEADER = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.REP.HEADER,1>
    R.FILE.DATA<-1> = REP.HEADER
    REP.NAME = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.REP.NAME,2>
    R.FILE.DATA<-1> = REP.NAME
    REP.DATE = 'FECHA Y HORA : ':TIMEDATE()
    R.FILE.DATA<-1> = REP.DATE
    REP.FIELDS = R.DR.REG.RIEN5.PARAM<RIEN5.PARAM.REP.FIELDS>
    CHANGE @VM TO '|' IN REP.FIELDS
    R.FILE.DATA<-1> = REP.FIELDS
RETURN

PROCESS.PARA:
*-----------*
*
    SEL.CMD1 = ''; ID.LIST1 = ''; ID.CNT1 = ''; ERR.SEL1 = ''
    SEL.CMD1 = "SELECT ":FN.DR.REG.RIEN5.REP2:" BY RATE"
    CALL EB.READLIST(SEL.CMD1, ID.LIST1, "", ID.CNT1, ERR.SEL1)
    ID.CTR1 = 1
    LOOP
    WHILE ID.CTR1 LE ID.CNT1
        AZ.ID = ID.LIST1<ID.CTR1>
        NEXT.AZ.ID = ID.LIST1<ID.CTR1+1>
        R.DR.REG.RIEN5.REP2 = ''; DR.REG.RIEN5.REP2.ERR = ''; DR.REG.RIEN5.REP2.1 = ''
        CALL F.READ(FN.DR.REG.RIEN5.REP2,AZ.ID,R.DR.REG.RIEN5.REP2,F.DR.REG.RIEN5.REP2,DR.REG.RIEN5.REP2.ERR)
        CALL F.READ(FN.DR.REG.RIEN5.REP2,NEXT.AZ.ID,R.DR.REG.RIEN5.REP2.1,F.DR.REG.RIEN5.REP2,DR.REG.RIEN5.REP2.ERR)
        CURR.RATE = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RATE>
        NEXT.RATE = R.DR.REG.RIEN5.REP2.1<DR.RIEN5.REP2.RATE>
        GOSUB GET.CURR.BAL
        IF CURR.RATE NE NEXT.RATE THEN
            GOSUB UPDATE.BALANCE
            GOSUB INIT.BAL
        END ELSE
            GOSUB SUM.BALANCE
        END
        ID.CTR1 += 1
    REPEAT
    RETURN.MSG = "TOTAL":'|':TOTRANGE1:'|':TOTRANGE2:'|':TOTRANGE3:'|':TOTRANGE4:'|':TOTRANGE5:'|':TOTRANGE6:'|':TOTRANGE7:'|':TOTRANGE8:'|':TOTRANGE9:'|':TOTRANGE10:'|':TOTRANGE11:'|':TOTINDET:'|':""
    R.FILE.DATA<-1> = RETURN.MSG
    WRITE R.FILE.DATA ON F.CHK.DIR, EXTRACT.FILE.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
RETURN
*-------------------------------------------------------------------
INIT.BAL:
*-------*
    BALANCE1 = ''; BALANCE2 = ''; BALANCE3 = ''; BALANCE4 = ''; BALANCE5 = ''; BALANCE6 = ''
    BALANCE7 = ''; BALANCE8 = ''; BALANCE9 = ''; BALANCE10 = ''; BALANCE11 = ''; BALANCE.INDET = ''
RETURN

GET.CURR.BAL:
*-----------*
    CURR.BAL1 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.0.15>
    CURR.BAL2 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.16.30>
    CURR.BAL3 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.31.60>
    CURR.BAL4 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.61.90>
    CURR.BAL5 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.91.180>
    CURR.BAL6 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.181.360>
    CURR.BAL7 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.361.720>
    CURR.BAL8 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.721.1080>
    CURR.BAL9 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.1081.1440>
    CURR.BAL10 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.1441.1800>
    CURR.BAL11 = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.RANGE.1881>
    CURR.INDET.BAL = R.DR.REG.RIEN5.REP2<DR.RIEN5.REP2.INDETERMINATE>   ;* PACS00309203 - Indeterminado field
RETURN
*-------------------------------------------------------------------
SUM.BALANCE:
*----------*
    BALANCE1 += CURR.BAL1
    BALANCE2 += CURR.BAL2
    BALANCE3 += CURR.BAL3
    BALANCE4 += CURR.BAL4
    BALANCE5 += CURR.BAL5
    BALANCE6 += CURR.BAL6
    BALANCE7 += CURR.BAL7
    BALANCE8 += CURR.BAL8
    BALANCE9 += CURR.BAL9
    BALANCE10 += CURR.BAL10
    BALANCE11 += CURR.BAL11
    BALANCE.INDET += CURR.INDET.BAL       ;* PACS00309203 - Indeterminado field

    CURR.BAL1 = ''; CURR.BAL2 = ''; CURR.BAL3 = ''; CURR.BAL4 = ''; CURR.BAL5 = ''; CURR.BAL6 = ''
    CURR.BAL7 = ''; CURR.BAL8 = ''; CURR.BAL9 = ''; CURR.BAL10 = ''; CURR.BAL11 = ''; CURR.INDET.BAL = ''
RETURN
*-------------------------------------------------------------------
UPDATE.BALANCE:
*-------------*
    YTEM.BAL1 = ''; YTEM.BAL2 = ''; YTEM.BAL3 = ''; YTEM.BAL4 = ''; YTEM.BAL5 = ''
    YTEM.BAL6 = ''; YTEM.BAL7 = ''; YTEM.BAL8 = ''; YTEM.BAL9 = ''; YTEM.BAL10 = ''
    YTEM.BAL11 = ''; YTEM.BAL12 = ''; YTEM.TOT = ''; RETURN.MSG = ''

    YTEM.BAL1 = BALANCE1 + CURR.BAL1
    YTEM.BAL2 = BALANCE2 + CURR.BAL2
    YTEM.BAL3 = BALANCE3 + CURR.BAL3
    YTEM.BAL4 = BALANCE4 + CURR.BAL4
    YTEM.BAL5 = BALANCE5 + CURR.BAL5
    YTEM.BAL6 = BALANCE6 + CURR.BAL6
    YTEM.BAL7 = BALANCE7 + CURR.BAL7
    YTEM.BAL8 = BALANCE8 + CURR.BAL8
    YTEM.BAL9 = BALANCE9 + CURR.BAL9
    YTEM.BAL10 = BALANCE10 + CURR.BAL10
    YTEM.BAL11 = BALANCE11 + CURR.BAL11
    YTEM.BAL12 = BALANCE.INDET + CURR.INDET.BAL     ;* PACS00309203 - Indeterminado field
    YTEM.TOT = YTEM.BAL1 + YTEM.BAL2 + YTEM.BAL3 + YTEM.BAL4 + YTEM.BAL5 + YTEM.BAL6 + YTEM.BAL7 + YTEM.BAL8 + YTEM.BAL9 + YTEM.BAL10 + YTEM.BAL11 + YTEM.BAL12
    RETURN.MSG = CURR.RATE:'|':YTEM.BAL1:'|':YTEM.BAL2:'|':YTEM.BAL3:'|':YTEM.BAL4:'|':YTEM.BAL5:'|':YTEM.BAL6:'|':YTEM.BAL7:'|':YTEM.BAL8:'|':YTEM.BAL9:'|':YTEM.BAL10:'|':YTEM.BAL11:'|':YTEM.BAL12:'|':YTEM.TOT
    R.FILE.DATA<-1> = RETURN.MSG
    GOSUB SUM.RANGE
RETURN
*-------------------------------------------------------------------
SUM.RANGE:
*--------*
    TOTRANGE1 += YTEM.BAL1
    TOTRANGE2 += YTEM.BAL2
    TOTRANGE3 += YTEM.BAL3
    TOTRANGE4 += YTEM.BAL4
    TOTRANGE5 += YTEM.BAL5
    TOTRANGE6 += YTEM.BAL6
    TOTRANGE7 += YTEM.BAL7
    TOTRANGE8 += YTEM.BAL8
    TOTRANGE9 += YTEM.BAL9
    TOTRANGE10 += YTEM.BAL10
    TOTRANGE11 += YTEM.BAL11
    TOTINDET += YTEM.TOT
RETURN
END
