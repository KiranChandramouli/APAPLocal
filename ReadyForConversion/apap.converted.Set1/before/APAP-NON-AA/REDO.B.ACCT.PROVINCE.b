*-------------------------------------------------------------------------------
* <Rating>-40</Rating>
*-------------------------------------------------------------------------------
    SUBROUTINE REDO.B.ACCT.PROVINCE(CRF.MBGL)
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
*-------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.COMPANY
    $INSERT TAM.BP I_REDO.B.ACCT.PROVINCE.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT T24.BP I_F.COMPANY

    GOSUB INIT
    RETURN
*-------------------------------------------------------------------------------
INIT:
*----
    CRF.DESC = ''
    CRF.CURRENCY = ''
    CRF.CUST.ID = ''
    CRF.DEAL.LCY.BAL = ''
    GOSUB SELECTION.PARA
    RETURN
*-------------------------------------------------------------------------------
SELECTION.PARA:
*--------------
    CRF.MBGL.ID = CRF.MBGL
    YCOMP.NME = FIELD(CRF.MBGL.ID,'.',3)
    YMNEMONIC = ''; ERR.COMP = ''; R.COMPANY1 = ''
    CALL CACHE.READ(FN.COMPANY,YCOMP.NME,R.COMPANY1,ERR.COMP)
    YMNEMONIC = R.COMPANY1<EB.COM.MNEMONIC>

    FN.RE.CRF.MBGL = 'F':YMNEMONIC:'.RE.CRF.MBGL'
    F.RE.CRF.MBGL = ''
    CALL OPF(FN.RE.CRF.MBGL,F.RE.CRF.MBGL)
    ERR.MBGL = ''; R.RE.CRF.MBGL = ''
    CALL F.READ(FN.RE.CRF.MBGL,CRF.MBGL.ID,R.RE.CRF.MBGL,F.RE.CRF.MBGL,ERR.MBGL)
    IF R.RE.CRF.MBGL THEN
        CRF.DESC         = R.RE.CRF.MBGL<2>
        CRF.CURRENCY     = R.RE.CRF.MBGL<1>
        CRF.CUST.ID      = R.RE.CRF.MBGL<12>
        CRF.DEAL.LCY.BAL = R.RE.CRF.MBGL<14>
    END
    IF CRF.CUST.ID EQ '' THEN
        RETURN
    END
    ACCT.CODE = CRF.DESC[1,3]

    LOCATE ACCT.CODE IN Y.COLUMN.ID SETTING COLU.POS THEN
        GOSUB PROCESS.PARA
    END
    RETURN

PROCESS.PARA:
*------------
    CALL F.READ(FN.CUSTOMER,CRF.CUST.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER THEN
        CUST.RESID   = R.CUSTOMER<EB.CUS.RESIDENCE>
        CUST.LOCALID = R.CUSTOMER<EB.CUS.LOCAL.REF,L.LOCALIDAD.POS>
    END
    IF CUST.RESID EQ 'DO' THEN
        CUST.LOCALID.LEN = LEN(CUST.LOCALID)
        IF CUST.LOCALID.LEN LT 6 THEN
            CUST.LOC.ID = FMT(CUST.LOCALID,"R%6")
        END ELSE
            CUST.LOC.ID = CUST.LOCALID
        END
        PROV.CODE = CUST.LOC.ID[1,2]
        CALL ALLOCATE.UNIQUE.TIME(Y.TIME)
        FILE.NAME1 = FILE.NAME:"*":Y.TIME
        Y.REC1 = PROV.CODE
        Y.REC2 = ACCT.CODE:"|":CRF.DEAL.LCY.BAL
        OUT.ARRAY = Y.REC1:FM:Y.REC2
        GOSUB WRITE.TO.FILE
    END ELSE
        ACCT.NO = FIELD(CRF.MBGL.ID,"*",4)
        CALL F.READ(FN.ACCOUNT,ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            ACC.CO.CODE = R.ACCOUNT<AC.CO.CODE>
            LOCATE 'CO.CODES.01' IN FIELD.NAME<1,1> SETTING CO.FOUND.POS THEN
                Y.CO.VALUE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE,CO.FOUND.POS>
                CHANGE SM TO FM IN Y.CO.VALUE
            END
            LOCATE ACC.CO.CODE IN Y.CO.VALUE SETTING CO.POS THEN
                CUR.PROV.CODE = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,CO.FOUND.POS,CO.POS>
            END
            CALL ALLOCATE.UNIQUE.TIME(Y.TIME)
            FILE.NAME1 = FILE.NAME:"*":Y.TIME
            Y.REC1 = CUR.PROV.CODE
            Y.REC2 = ACCT.CODE:"|":CRF.DEAL.LCY.BAL
            OUT.ARRAY = Y.REC1:FM:Y.REC2
            GOSUB WRITE.TO.FILE
        END
    END
    RETURN

WRITE.TO.FILE:
*-------------
    Y.FILE.NAME = FILE.NAME1
    Y.OUT.ARRAY = OUT.ARRAY
    OPEN TEMP.PATH TO TEMP.PATH1 THEN
        WRITE Y.OUT.ARRAY TO TEMP.PATH1,Y.FILE.NAME
    END
    RETURN
END
