* @ValidationCode : MjotMjAwMDcwMDQ5ODpDcDEyNTI6MTY4NDg1MTk3OTY1MTpJVFNTOi0xOi0xOjMxMjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 312
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOFILE.AZ.PROFIT.LOSS(FINAL.ARR)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
* This is the NOFILE enquiry routine of the enquiry REDO.NOFILE.AZ.PROFILT.LOSS and
*  it is attached to the STANDARD.SELECTION record NOFILE.AZ.PROFIT.LOSS
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT :
*  FINAL.ARR - Contains the details to be displayed in the enquiry output
*
* Dependencies:
*---------------
* CALLS     :
*  REDO.E.FORM.SEL.STMT - Returns the select statement based on the incoming file name and
*                           the selection criteria values stored in the enquiry common variables
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
*
* 28-JUN-2010  N.Satheesh Kumar   ODR-2009-10-0325       Initial Creation
*---------------------------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM and VM to @VM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOENQ
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB GET.ACC.IDS
    GOSUB GET.CUS.IDS
    GOSUB PROCESS

RETURN

*----------
INITIALISE:
*----------
*----------------------------------------------------------------------------------------------------------------------
* This section initialises necessary variables used in this routine and gets the position of the local reference fields
*----------------------------------------------------------------------------------------------------------------------

    CUST.ID.LST = ''
    AZ.ACC.ID.LST = ''
    FINAL.ARR = ''
    DELIM = '*'
    CUS.FLAG = 0
    LR.FIELDS = 'L.EB.PROFITLOSS':@VM:'L.EB.TASA.POOL'
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF('AZ.ACCOUNT',LR.FIELDS,LRF.POS)
    PRO.LOS.POS = LRF.POS<1,1>
    POOL.RATE.POS = LRF.POS<1,2>

RETURN

*----------
OPEN.FILES:
*----------
*-----------------------------------
* This section opens necessary files
*-----------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMR = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
RETURN

*-----------
GET.ACC.IDS:
*-----------
*--------------------------------------------------------------------------------------------------------------------
* This section selects the AZ.ACCOUNT ids based on the select statement formed using the routine REDO.E.FORM.SEL.STMT
*--------------------------------------------------------------------------------------------------------------------

    VALUE.BK = D.RANGE.AND.VALUE
    OPERAND.BK = D.LOGICAL.OPERANDS
    FIELDS.BK = D.FIELDS

    CUS.APP.FLDS = 'SECTOR':@FM:'ACCT.OFFICER'

    LOOP
        REMOVE CUS.FLD FROM CUS.APP.FLDS SETTING CUS.FLD.POS
    WHILE CUS.FLD:CUS.FLD.POS
        LOCATE CUS.FLD IN D.FIELDS<1> SETTING CUS.POS THEN
            GOSUB UPDATE.COM.VAR
        END
    REPEAT

    FILE.NAME = FN.AZ.ACCOUNT
    CALL APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.AZ.ACC.CMD)   ;*R22 Manual Conversion - Added APAP.REDOENQ
    CALL EB.READLIST(SEL.AZ.ACC.CMD,AZ.ACC.ID.LST,'',NO.OF.REC,SEL.ERR)
RETURN

*--------------
UPDATE.COM.VAR:
*--------------
*----------------------------------------------------------------------------------------------------------------------
* This section removes the selection criteria details related to cusotmer application from the enquiry common variables
*   and stores it in temporary variable to select AZ.ACCOUNT ids
*----------------------------------------------------------------------------------------------------------------------

    CUS.VALUE<-1> = D.RANGE.AND.VALUE<CUS.POS>
    CUS.OPERAND<-1> = D.LOGICAL.OPERANDS<CUS.POS>
    CUS.FIELD<-1> = D.FIELDS<CUS.POS>
    CUS.FLAG = 1
    DEL D.FIELDS<CUS.POS>
    DEL D.LOGICAL.OPERANDS<CUS.POS>
    DEL D.FIELDS<CUS.POS>
RETURN

*-----------
GET.CUS.IDS:
*-----------
*----------------------------------------------------------------------------------------------------------------------
* This section stores the selection criteria details related to cusotmer application in the enquiry common variables
*   to get the CUSTOMER ids based on the selction criteria entered by user and restores the original values in the
*      enquiry common variables
*----------------------------------------------------------------------------------------------------------------------

    IF CUS.FLAG THEN
        D.RANGE.AND.VALUE = CUS.VALUE
        D.LOGICAL.OPERANDS = CUS.OPERAND
        D.FIELDS = CUS.FIELD
        FILE.NAME = FN.CUSTOMER
        CALL APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.CUS.CMD)	 ;*R22 Manual Conversion - Added APAP.REDOENQ
        SEL.ERR = ''
        CUS.REC.CNT = ''
        CALL EB.READLIST(SEL.CUS.CMD,CUST.ID.LST,'',CUS.REC.CNT,SEL.ERR)
        D.RANGE.AND.VALUE = VALUE.BK
        D.LOGICAL.OPERANDS = OPERAND.BK
        D.FIELDS = FIELDS.BK
    END
RETURN

*-------
PROCESS:
*-------
*------------------------------------------------------------------------------------
* This section reads AZ.ACCOUNT file and assigns the necessary values to the variable
*------------------------------------------------------------------------------------

    LOOP
        REMOVE AZ.ACC.ID FROM AZ.ACC.ID.LST SETTING AZ.ACC.ID.POS
    WHILE AZ.ACC.ID:AZ.ACC.ID.POS
        R.AZ.ACCOUNT = ''
        CALL F.READ(FN.AZ.ACCOUNT,AZ.ACC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACC.ERR)
        ACC.CUST = R.AZ.ACCOUNT<AZ.CUSTOMER>
        IF CUS.REC.CNT THEN
            LOCATE ACC.CUST IN CUST.ID.LST SETTING CUS.POS THEN
                GOSUB GET.CUST.INFO
                GOSUB UPDATE.ARR
            END
        END ELSE
            GOSUB GET.CUST.INFO
            GOSUB UPDATE.ARR
        END
    REPEAT
    DEL FINAL.ARR<1>
RETURN

*----------
UPDATE.ARR:
*----------
*----------------------------------------------------------------------------------------------------------
* This section assigns the value to be displayed in the enquiry for each AZ.ACCOUNT to the variable IND.ARR
*  and the value in the IND.ARR is appended to the out going varible which contains all the details to be
*   displayed in the enquiry
*----------------------------------------------------------------------------------------------------------

    IND.ARR=''
    IND.ARR = R.AZ.ACCOUNT<AZ.CATEGORY>:DELIM
    IND.ARR := ACC.CUST:DELIM
    IND.ARR := CUST.NAME:DELIM
    IND.ARR := R.AZ.ACCOUNT<AZ.CO.CODE>:DELIM
    IND.ARR := ACCT.OFFICER:DELIM
    IND.ARR := R.AZ.ACCOUNT<AZ.PRINCIPAL>:DELIM
    IND.ARR := R.AZ.ACCOUNT<AZ.INTEREST.RATE>:DELIM
*IND.ARR := R.AZ.ACCOUNT<AZ.LOCAL.REF,PRO.LOS.POS>:DELIM
    IND.ARR := R.AZ.ACCOUNT<AZ.LOCAL.REF,POOL.RATE.POS>:DELIM
    IND.ARR := R.AZ.ACCOUNT<AZ.LOCAL.REF,PRO.LOS.POS>:DELIM
    IND.ARR := R.AZ.ACCOUNT<AZ.MATURITY.DATE>:DELIM
    FINAL.ARR := @FM:IND.ARR
RETURN

*-------------
GET.CUST.INFO:
*-------------
*------------------------------------------------------------------------------------
* This section reads CUSTOMER record and assigns the necessary values to the variable
*------------------------------------------------------------------------------------

    R.CUSTOMER = ''
    CUST.NAME = ''
    ACCT.OFFICER = ''
    CALL F.READ(FN.CUSTOMER,ACC.CUST,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
    CUST.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
    ACCT.OFFICER = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
RETURN
END
