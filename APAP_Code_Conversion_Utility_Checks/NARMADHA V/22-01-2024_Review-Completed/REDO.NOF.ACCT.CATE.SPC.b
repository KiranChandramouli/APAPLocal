* @ValidationCode : MjotNDcwMjczMDg4OlVURi04OjE3MDU5MTc4NDc0NDY6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 15:34:07
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.ACCT.CATE.SPC(Y.FINAL.ARR)


* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.NOF.ACCT.CATE.SPC
* ODR NUMBER    : PACS00099482 - ODR-2011-01-0492
*--------------------------------------------------------------------------------------
* Description   : This no-file enquiry routine attached with the enquiry REDO.NOF.ACCT.CATE.SPC.ENQ
* In parameter  : none
* out parameter : none
*--------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE                      DESCRIPTION
*
* 05-08-2011      MARIMUTHU S     PACS00099482                      Initial creation
* 19-01-2024      Narmadha V      R22 Utility Changes               ID variable changed instead of hardcoding
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM

MAIN:

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
RETURN

OPENFILES:

    FN.REDO.INV.PARAM = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.INV.PARAM = ''

    FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

PROCESS:


*CALL CACHE.READ(FN.REDO.INV.PARAM,'SYSTEM',R.REDO.INV.PARAM,INV.PAR.ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 Utility Changes
    CALL CACHE.READ(FN.REDO.INV.PARAM,IDVAR.1,R.REDO.INV.PARAM,INV.PAR.ERR);* R22 Utility Changes
    Y.MAIN.TYPES = R.REDO.INV.PARAM<IN.PR.INV.MAINT.TYPE>
    Y.MAIN.TYPES = CHANGE(Y.MAIN.TYPES,@VM,@FM)


*CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.REDO.ADMIN.CHQ.PARAM,PAR.ERRR)
    IDVAR.1 = 'SYSTEM' ;* R22 Utility Changes
    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,IDVAR.1,R.REDO.ADMIN.CHQ.PARAM,PAR.ERRR);* R22 Utility Changes

    Y.CNT = DCOUNT(Y.MAIN.TYPES,@FM)
    CNT = 1 ; Y.CATEGS = ''
    LOOP
    WHILE CNT LE Y.CNT
        LOCATE 'ADMIN.CHEQUES' IN Y.MAIN.TYPES<CNT> SETTING POS.EX THEN
            Y.DUP.ITEM.CODE = R.REDO.INV.PARAM<IN.PR.ITEM.CODE,POS.EX>
            Y.ITEM.CODES = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ITEM.CODE>
            LOCATE Y.DUP.ITEM.CODE IN Y.ITEM.CODES<1,1> SETTING POS.XX THEN
                IF Y.CATEGS EQ '' THEN
                    Y.CATEGS = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,POS.XX>
                END ELSE
                    Y.CATEGS := @FM:R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,POS.XX>
                END
            END

            CNT = POS.EX+1
*            CNT = Y.CNT + 1
        END ELSE
            CNT = Y.CNT + 1
        END
    REPEAT

    Y.FINAL.ARR = Y.CATEGS


RETURN

PROGRAM.END:
RETURN
END
