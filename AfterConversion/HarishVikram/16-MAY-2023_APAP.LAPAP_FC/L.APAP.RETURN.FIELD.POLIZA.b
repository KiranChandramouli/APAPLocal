$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.RETURN.FIELD.POLIZA(POLI.NUN,OUT.RECORD)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : POLI.NUN
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : OUT.RECORD

* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
*$INCLUDE BP I_F.ST.L.APAP.POLIZA.SEGURO.RNC
* $INSERT TAM.BP I_REDO.B.CR.GUARANTEE.COMMON
* </region>
*-----------------------------------------------------------------------------
    GOSUB MAIN.PROCESS
RETURN
*------------
MAIN.PROCESS:
*------------
    OUT.RECORD = ""
    NUMERO.POLIZA = POLI.NUN
    Y.POLICY.ORG.DATE = ''
    Y.AMOUNT = 0
    Y.SEN.POLICY.NUMBER = ''
    Y.COMPANY.POLIZA = ''
    Y.RNC = ''
    GOSUB APAP.H.INSURANCE.DETAILS.GET
    GOSUB POLIZA.SEGURO.RNC.GET
    GOSUB FORM.ARRAY
RETURN
*-------------------
APAP.H.INSURANCE.DETAILS.GET:
**------------------
    FN.IN = "F.APAP.H.INSURANCE.DETAILS"
    FV.IN = ""
    CALL OPF(FN.IN,FV.IN)
    SEL.CMD = ""
    SEL.LIST = ""
    NO.OF.RECS = ""
    SEL.ERR = ""

    SEL.CMD = "SELECT " : FN.IN : " WITH POLICY.NUMBER EQ " : NUMERO.POLIZA
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)

    LOOP
        REMOVE Y.IN.ID FROM SEL.LIST SETTING FI.POS
    WHILE Y.IN.ID DO
        R.IN = ""; IN.ERROR = ""
        CALL F.READ(FN.IN, Y.IN.ID, R.IN, FV.IN, IN.ERROR)
        Y.POLICY.ORG.DATE = R.IN<INS.DET.POLICY.ORG.DATE>
        Y.AMOUNT = R.IN<INS.DET.INS.AMOUNT>
        Y.SEN.POLICY.NUMBER = R.IN<INS.DET.SEN.POLICY.NUMBER>
        Y.COMPANY.POLIZA = R.IN<INS.DET.INS.COMPANY>
    REPEAT
    IF NOT(Y.SEN.POLICY.NUMBER) THEN
        Y.SEN.POLICY.NUMBER = NUMERO.POLIZA
    END
RETURN
*--------------------
POLIZA.SEGURO.RNC.GET:
    FN.POLIZA = "F.ST.L.APAP.POLIZA.SEGURO.RNC"
    FV.POLIZA = ""
    CALL OPF(FN.POLIZA,FV.POLIZA)
    R.POLIZA = ""; R.ERROR = ""
    Y.RNC1 = ''; Y.RNC2 = ''; Y.RNC3 = ''; Y.RNC4 = ''
    CALL F.READ(FN.POLIZA,Y.COMPANY.POLIZA,R.POLIZA,FV.POLIZA,R.ERROR)
*Y.RNC = R.POLIZA<ST.L.A42.L.APAP.RNC.SEGURO>
    Y.RNC = R.POLIZA<2>
    IF Y.RNC NE '' THEN
        Y.RNC1 = Y.RNC[1,1]
        Y.RNC2 = Y.RNC[2,2]
        Y.RNC3 = Y.RNC[3,5]
        Y.RNC4 = Y.RNC[9,1]
        Y.RNC = Y.RNC1:"-":Y.RNC2:"-":Y.RNC3:"-":Y.RNC4
    END
RETURN
*--------------------

FORM.ARRAY:
*---------
    OUT.RECORD = Y.POLICY.ORG.DATE:"*":Y.AMOUNT:"*":Y.SEN.POLICY.NUMBER:"*":Y.RNC

RETURN
END
