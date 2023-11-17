* @ValidationCode : MjotNjcwNTYxNjE4OkNwMTI1MjoxNjgyMzMxMzIyNDM4OklUU1M6LTE6LTE6MzAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 300
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.FR.CL.AUT.CC.RT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.FRONT.CLAIMS
    $INSERT I_F.REDO.ISSUE.CLAIMS


    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)
    SEL.CMD = ""
    SEL.LIST = ""
    NO.OF.RECS = ""
    SEL.ERR = ""

    Y.CUST.CODE.IN = R.NEW(FR.CL.CUSTOMER.CODE)
    Y.CUST.CODE.OUT = Y.CUST.CODE.IN
    CALL F.READ(FN.CUS,Y.CUST.CODE.IN,R.CUS, FV.CUS, CUS.ERR)
    IF R.CUS NE '' THEN
        Y.CUST.CODE.OUT = Y.CUST.CODE.IN
    END
    IF R.CUS EQ '' THEN
        SEL.CMD = "SELECT " : FN.CUS : " WITH L.CU.CIDENT EQ " : Y.CUST.CODE.IN
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
        LOOP REMOVE Y.CUSTOMER.CODE FROM SEL.LIST SETTING STMT.POS

        WHILE Y.CUSTOMER.CODE DO
            CALL F.READ(FN.CUS,Y.CUSTOMER.CODE,R.CUS, FV.CUS, CUS.ERR)
            IF R.CUS NE '' THEN
                Y.CUST.CODE.OUT = Y.CUSTOMER.CODE
            END
        REPEAT
    END
    R.NEW(ISS.CL.CUSTOMER.CODE) = Y.CUST.CODE.OUT
RETURN
END
