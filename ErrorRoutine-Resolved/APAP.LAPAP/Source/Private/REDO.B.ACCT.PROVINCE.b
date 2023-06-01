* @ValidationCode : MjoyMDQzMzQ3NjUzOkNwMTI1MjoxNjg1NjE5NTg4MTgyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 01 Jun 2023 17:09:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.ACCT.PROVINCE(PROV.MBGL)
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description:
*-------------------------------------------------------------------------------
* Modification History
* Defect Reference       Modified By                    Date of Change        Change Details
*
*-----------------------------------------------------------------------------------------------------------------
*                       Ashokkumar.V.P                  17/02/2016           Changes to avoid the customer data issue
*23/05/2023      CONVERSION TOOL         AUTO R22 CODE CONVERSION             = to EQ, BP Removed in insertfile
*23/05/2023      HARISH VIKRAM           MANUAL R22 CODE CONVERSION           LCOMP.LOCALIDAD.POS  added in Insert file   I_REDO.B.ACCT.PROVINCE.COMMON

*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY
    $INSERT I_REDO.B.ACCT.PROVINCE.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM

    GOSUB INIT
    GOSUB SELECTION.PARA
RETURN
*-------------------------------------------------------------------------------
INIT:
*----
    CRF.DESC = '';    CRF.CURRENCY = ''; ACCT.NO = ''
    CRF.CUST.ID = ''; CRF.DEAL.LCY.BAL = ''; YREP.LINE = ''
    ERR.MBGL = ''; R.RE.CRF.MBGL = ''
    YMNEMONIC = ''; ERR.COMP = ''; R.COMPANY1 = ''
RETURN
*-------------------------------------------------------------------------------
SELECTION.PARA:
*--------------
    CRF.MBGL.ID = PROV.MBGL
    YCOMP.NME = FIELD(CRF.MBGL.ID,'.',3)
    IF LEN(YCOMP.NME) NE 9 THEN
        YCOMP.NME = LEFT(YCOMP.NME,9)
    END
    CALL F.READ(FN.COMPANY,YCOMP.NME,R.COMPANY1,FV.COMPANY,ERR.COMP)
    YMNEMONIC = R.COMPANY1<EB.COM.MNEMONIC>
    FN.RE.CRF.MBGL = 'F':YMNEMONIC:'.RE.CRF.MBGL'
    F.RE.CRF.MBGL = ''
    CALL OPF(FN.RE.CRF.MBGL,F.RE.CRF.MBGL)
    CALL F.READ(FN.RE.CRF.MBGL,CRF.MBGL.ID,R.RE.CRF.MBGL,F.RE.CRF.MBGL,ERR.MBGL)
    IF R.RE.CRF.MBGL THEN
        CRF.DESC         = R.RE.CRF.MBGL<2>
        CRF.CURRENCY     = R.RE.CRF.MBGL<1>
        CRF.CUST.ID      = R.RE.CRF.MBGL<12>
        CRF.DEAL.LCY.BAL = R.RE.CRF.MBGL<14>
        ACCT.NO = FIELD(CRF.MBGL.ID,"*",4)
    END
    IF NOT(CRF.DEAL.LCY.BAL) THEN
        CRF.DEAL.LCY.BAL = R.RE.CRF.MBGL<13>
    END
    IF CRF.CUST.ID EQ '' THEN
        R.ACCOUNT = ''; ACC.ERR = ''
        CALL F.READ(FN.ACCOUNT,ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF NOT(R.ACCOUNT) THEN
            ACC.ERR = ''
            CALL EB.READ.HISTORY.REC(F.ACCOUNT.H,ACCT.NO,R.ACCOUNT,ACC.ERR)
        END
        IF R.ACCOUNT THEN
            CRF.CUST.ID = R.ACCOUNT<AC.CUSTOMER>
        END
    END
    IF NOT(CRF.CUST.ID) THEN
        RETURN
    END

    ACCT.CODE = CRF.DESC[1,3]

    LOCATE ACCT.CODE IN Y.COLUMN.ID SETTING COLU.POS THEN
        GOSUB PROCESS.PARA
    END
RETURN

PROCESS.PARA:
*------------
    R.CUSTOMER = ''; CUS.ERR = ''; CUS.RESID = ''; CUS.LOCALID = ''
    CUST.LOC.ID = ''; PROV.CODE = ''; OUT.ARRAY = ''
    CALL F.READ(FN.CUSTOMER,CRF.CUST.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF NOT(R.CUSTOMER) THEN
        CUS.ERR = ''
        CALL EB.READ.HISTORY.REC(F.CUSTOMER.H,CRF.CUST.ID,R.CUSTOMER,CUS.ERR)
    END
    IF R.CUSTOMER THEN
        CUST.RESID   = R.CUSTOMER<EB.CUS.RESIDENCE>
        CUST.LOCALID = R.CUSTOMER<EB.CUS.LOCAL.REF,L.LOCALIDAD.POS>
    END
    IF NOT(CUST.LOCALID) THEN
        ERR.COMP = ''; R.COMP.NME = ''; YCUST.COMP = ''
        YCUST.COMP = R.CUSTOMER<EB.CUS.COMPANY.BOOK>
        CALL F.READ(FN.COMPANY,YCUST.COMP,R.COMP.NME,FV.COMPANY,ERR.COMP)
        CUST.LOCALID = R.COMPANY1<EB.COM.LOCAL.REF,LCOMP.LOCALIDAD.POS>
    END
    CUST.LOCALID.LEN = LEN(CUST.LOCALID)
    IF CUST.LOCALID.LEN LT 6 THEN
        CUST.LOC.ID = FMT(CUST.LOCALID,"R%6")
    END ELSE
        CUST.LOC.ID = CUST.LOCALID
    END
    PROV.CODE = CUST.LOC.ID[1,2]
    IF ACCT.CODE NE '177' THEN
        OUT.ARRAY = PROV.CODE:"|":ACCT.CODE:"|":CRF.DEAL.LCY.BAL
        GOSUB WRITE.TO.FILE
    END ELSE
        YREP.LINE = FIELD(CRF.MBGL.ID,"*",1)
        YBAL.TYPE = FIELD(CRF.MBGL.ID,"*",5)
        IF YREP.LINE[1,9] EQ 'MBGL.9999' THEN
            CRF.MBGL.ID = '177-':CRF.MBGL.ID
            OUT.ARRAY = ACCT.NO:",":CRF.CUST.ID:",":CUST.LOC.ID:",":ACCT.CODE:",":YBAL.TYPE:",":CRF.DEAL.LCY.BAL
            GOSUB WRITE.TO.FILE
        END
    END
RETURN

WRITE.TO.FILE:
*-------------
    CALL F.WRITE(FN.DR.REG.PROV.WORKFILE,CRF.MBGL.ID,OUT.ARRAY)
RETURN
END
