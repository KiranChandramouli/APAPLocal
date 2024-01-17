* @ValidationCode : MjotMTA0NzM1MDYxOTpDcDEyNTI6MTcwNDgwMDIyNTIxMzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 17:07:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.STATUS.UPDATE(Y.CUSTOMER.ID)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This Batch routine will update the value of CUSTOMER.STATUS field in customer
*application
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : Y.CUSTOMER.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 02-JAN-2010       Prabhu.N        ODR-2009-10-0535      Initial Creation
* 23-SEP-2010       H Ganesh        ODR-2010-09-0216      CR-013 Amended
* 21-SEP-2011       Pradeeep S      PACS00090815          Credit Card status considered
* 29-Jan-2012    Gangadhar.S.V.  Performance Tuning   New condition to check CUSTOMER.TYPE NE 'PROSPECT'
* 09-MAR-2012       Prabhu           PACS00185456         issue fixed to support to set customer status to 2 for  INCTIVE/CLOSED account combination
* 27-JUN-2017       Saran            PACS00605376         Customer Status different in R09 vs R15
* Date                   who                   Reference
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO += 1
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_System
    $INSERT JBC.h
    $INSERT I_F.REDO.SUNNEL.METHOD
    $INSERT I_F.REDO.SUNNEL.PARAMETER
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_REDO.B.STATUS.UPDATE.COMMON
    $USING APAP.REDOCHNLS

    GOSUB INIT
    IF CUST.TYPE NE 'PROSPECT' THEN     ;* 29-Jan-2012 - S/E
        GOSUB UPD.CUST.ACT
        GOSUB UPD.CUST.INACT
        GOSUB UPD.CUST.CLOSED
        GOSUB UPD.CUST.AC.CLOSED
        GOSUB UPD.DECEASED
        GOSUB UPD.CC.STATUS
        GOSUB WR.CUST
    END   ;* 29-Jan-2012 - S/E
RETURN
*-----
INIT:
*----

    R.CUST.PRD.LIST=''
    Y.CUST.STATUS.LIST=''
    Y.CUST.STATUS=''
*    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERROR)
    CALL F.READU(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERROR,'');* R22 UTILITY AUTO CONVERSION
    CUST.TYPE = ''  ;* 29-Jan-2012 - S
    CUST.TYPE = R.CUSTOMER<EB.CUS.CUSTOMER.TYPE>
    IF CUST.TYPE NE 'PROSPECT' THEN     ;* 29-Jan-2012 - E
        CALL F.READ(FN.CUST.PRD.LIST,Y.CUSTOMER.ID,R.CUST.PRD.LIST,F.CUST.PRD.LIST,CUS.ERR)
        Y.CUST.STATUS.LIST= R.CUST.PRD.LIST<PRD.PRD.STATUS>
        Y.CUST.TYPE       = R.CUST.PRD.LIST<PRD.TYPE.OF.CUST>
        CHANGE @VM TO @FM IN Y.CUST.STATUS.LIST
        Y.CUST.STATUS.LIST.SIZE=DCOUNT(Y.CUST.STATUS.LIST,@FM)
    END   ;* 29-Jan-2012 - S/E
RETURN

*--------------
UPD.CUST.ACT:
*---------------
*Check if there is any active products for the customer if so set Y.CUST.STATUS = 1

    IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> EQ '2' THEN
        LOCATE 'ACTIVE' IN Y.CUST.STATUS.LIST SETTING ACT.POS THEN
            Y.CUST.STATUS='1'
        END
    END
RETURN
*--------------
UPD.CUST.INACT:
*--------------

*-------------Change Customer status to inactive if all products are inactive--------------

    IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> EQ '1' THEN
        POS=1
        LOOP
        WHILE  POS LE Y.CUST.STATUS.LIST.SIZE AND ( Y.CUST.STATUS.LIST<POS> EQ 'INACTIVE' OR Y.CUST.STATUS.LIST<POS> EQ 'CLOSED' )
            POS+=1
        REPEAT
        IF POS GT Y.CUST.STATUS.LIST.SIZE THEN
            Y.CUST.STATUS='2'
        END
    END
RETURN

*---------------
UPD.CUST.CLOSED:
*---------------

*---------------Change customer status to closed if all the products are closed------------

    IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> NE '4' THEN
        POS=1
        LOOP
        WHILE  POS LE Y.CUST.STATUS.LIST.SIZE AND Y.CUST.STATUS.LIST<POS> EQ 'CLOSED'
            POS+=1
        REPEAT

        IF POS GT Y.CUST.STATUS.LIST.SIZE THEN
            CALL F.READ(FN.CORPORATE.CUSTOMER.LIST,Y.CUSTOMER.ID,R.CORPORATE.CUSTOMER.LIST,F.CORPORATE.CUSTOMER.LIST,CORPORATE.CUSTOMER.LIST.ERR)
            IF R.CORPORATE.CUSTOMER.LIST THEN
                RETURN
            END
            Y.CUST.STATUS='4'
        END
    END
RETURN
*------------------
UPD.CUST.AC.CLOSED:
*-------------------

*------------change customer status to closed if no product opened after customer becomes active----

    IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> EQ 1 THEN
        CUSTOMER.HIS.ID=Y.CUSTOMER.ID : ';' : R.CUSTOMER<EB.CUS.CURR.NO>-1
*        CALL F.READ(FN.CUSTOMER.HIS,CUSTOMER.HIS.ID,R.CUSTOMER.HIS,F.CUSTOMER.HIS,CUS.ERROR)
        CALL F.READU(FN.CUSTOMER.HIS,CUSTOMER.HIS.ID,R.CUSTOMER.HIS,F.CUSTOMER.HIS,CUS.ERROR,'');* R22 UTILITY AUTO CONVERSION
        IF R.CUSTOMER.HIS<EB.CUS.CUSTOMER.STATUS> EQ 4 THEN
            LOCATE 'ACTIVE' IN Y.CUST.STATUS.LIST  SETTING POS  ELSE
                LOCATE 'INACTIVE' IN Y.CUST.STATUS.LIST  SETTING POS ELSE
                    Y.CUST.STATUS='4'
                END
            END
        END
    END
RETURN
*------------
UPD.DECEASED:
*------------

*----------change all the product of customer to deceased if customer status is deceased-------

    YDECEAS.FLG = 0
    IF R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> EQ 3 THEN
*        CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUSTOMER.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,ERR)
        CALL F.READU(FN.CUSTOMER.ACCOUNT,Y.CUSTOMER.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,ERR,'');* R22 UTILITY AUTO CONVERSION
*        CHANGE VM TO FM IN R.CUSTOMER.ACCOUNT ;* 29-Jan-2012 - S/E - R.CUSTOMER.ACCOUNT is already with FM
        NO.OF.REC=DCOUNT(R.CUSTOMER.ACCOUNT,@FM)

        FOR CNT=1 TO NO.OF.REC
            CALL F.READ(FN.ACCOUNT,R.CUSTOMER.ACCOUNT<CNT>,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            Y.STATUS2.LIST=R.ACCOUNT<AC.LOCAL.REF,AC.STATUS2.POS>
            Y.STATUS2.LIST.SIZE=DCOUNT(Y.STATUS2.LIST,@SM)
            CHANGE @SM TO @FM IN Y.STATUS2.LIST
            LOCATE 'DECEASED' IN Y.STATUS2.LIST SETTING DEC.POS ELSE
                R.ACCOUNT<AC.LOCAL.REF,AC.STATUS2.POS,Y.STATUS2.LIST.SIZE+1>='DECEASED'
                CALL F.LIVE.WRITE(FN.ACCOUNT,R.CUSTOMER.ACCOUNT<CNT>,R.ACCOUNT)
            END
        NEXT CNT
*---------------------------------------------
* CR-013 - Code Modified
*---------------------------------------------
        CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.CUSTOMER.ID,R.JOINT.HOLDER,F.JOINT.CONTRACTS.XREF,JOINT.ERR)
*        CHANGE VM TO FM IN R.JOINT.HOLDER ;* 29-Jan-2012 - S/E - R.JOINT.HOLDER already with FM
        NO.OF.JNT.REC=DCOUNT(R.JOINT.HOLDER,@FM)

        VAR1=1
        LOOP
        WHILE VAR1 LE NO.OF.JNT.REC
            CALL F.READ(FN.ACCOUNT,R.JOINT.HOLDER<VAR1>,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            Y.JOINT.HOLDER=R.ACCOUNT<AC.JOINT.HOLDER>
            Y.RELATION.CODE=R.ACCOUNT<AC.RELATION.CODE>
            CHANGE @VM TO @FM IN Y.JOINT.HOLDER
            CHANGE @VM TO @FM IN Y.RELATION.CODE
            LOCATE Y.CUSTOMER.ID IN Y.JOINT.HOLDER SETTING JOINT.POS THEN
                IF Y.RELATION.CODE<JOINT.POS> GE 500 AND Y.RELATION.CODE<JOINT.POS> LE 509 THEN
                    Y.STATUS2.LIST=R.ACCOUNT<AC.LOCAL.REF,AC.STATUS2.POS>
                    Y.STATUS2.LIST.SIZE=DCOUNT(Y.STATUS2.LIST,@SM)
                    CHANGE @SM TO @FM IN Y.STATUS2.LIST

                    LOCATE 'DECEASED' IN Y.STATUS2.LIST SETTING DEC.POS ELSE
                        R.ACCOUNT<AC.LOCAL.REF,AC.STATUS2.POS,Y.STATUS2.LIST.SIZE+1>='DECEASED'
                        CALL F.LIVE.WRITE(FN.ACCOUNT,R.JOINT.HOLDER<VAR1>,R.ACCOUNT)
                    END
                END
            END

            VAR1 += 1
        REPEAT
* Upgrade Change 20161121 Start
        YDECEAS.FLG = 1
* Upgrade Change 20161121 End
*---------------------------CR-013 END--------------------------------------
    END
RETURN

*-------------
UPD.CC.STATUS:
*-------------
* New section included to check credit card status
* PACS00090815

    IF Y.CUST.STATUS NE '1' OR NOT(R.CUST.PRD.LIST) THEN
* Upgrade Change 20161121 Start
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,CU.TARJ.POS> EQ 'YES' AND YDECEAS.FLG EQ 0 THEN
* Upgrade Change 20161121 End
            Y.CUST.STATUS = 1
        END
    END
RETURN

*-------------
CHECK.SUNNEL:
*-------------

    GOSUB GET.SUNNEL.PARAM.VALUE
    GOSUB GET.SUNNEL.METHOD.VALUE

*Method
    Y.ARRAY  = Y.METHOD.NAME:Y.SEC.MARKER
*In Parameter
    Y.ARRAY := Y.CUSTOMER.ID:Y.IN.SF.MARKER:Y.FIELD.NAME:Y.IN.SF.MARKER:Y.FIELD.TYPE:Y.SEC.MARKER
*Out Parameter
    Y.OUT.FLD.CNT = DCOUNT(Y.OUT.NAME,@FM)
    Y.FLD.CNT = 1
    LOOP
    WHILE Y.FLD.CNT LE Y.OUT.FLD.CNT
        IF Y.FLD.CNT EQ Y.OUT.FLD.CNT THEN
            Y.ARRAY :=Y.OUT.NAME<Y.FLD.CNT>:Y.IN.SF.MARKER:Y.OUT.TYPE<Y.FLD.CNT>
        END ELSE
            Y.ARRAY :=Y.OUT.NAME<Y.FLD.CNT>:Y.IN.SF.MARKER:Y.OUT.TYPE<Y.FLD.CNT>:Y.IN.FLD.MAKER
        END
        Y.FLD.CNT += 1
    REPEAT

    Y.RESPONSE = CALLJEE(Y.ACTIVATION.KEY,Y.ARRAY)

    CHANGE Y.OUT.DELIM TO @FM IN Y.ARRAY
    CHANGE Y.OT.VAL.MARK TO @VM IN Y.ARRAY
    CHANGE Y.OT.SUB.MARK TO @SM IN Y.ARRAY

    IF Y.ARRAY<3> EQ '-1' THEN
        Y.CC.STATUS = 'C'
        GOSUB UPDATE.C22.LOG
    END
    IF Y.ARRAY<3> EQ '0' THEN
        Y.CC.STATUS = Y.ARRAY<2>
    END

RETURN

*----------------------
GET.SUNNEL.PARAM.VALUE:
*----------------------

    Y.SEC.MARKER     = R.REDO.SUNNEL.PARAMETER<SP.SEC.MARKER>
    Y.ACTIVATION.KEY = R.REDO.SUNNEL.PARAMETER<SP.ACT.KEY>
    Y.IN.SF.MARKER   = R.REDO.SUNNEL.PARAMETER<SP.IN.SF.MARKER>
    Y.IN.FLD.MAKER   = R.REDO.SUNNEL.PARAMETER<SP.IN.FLD.MARKER>
    Y.OUT.DELIM      = R.REDO.SUNNEL.PARAMETER<SP.OT.FLD.MARKER>
    Y.OT.VAL.MARK    = R.REDO.SUNNEL.PARAMETER<SP.OT.VAL.MARKER>
    Y.OT.SUB.MARK    = R.REDO.SUNNEL.PARAMETER<SP.OT.SUB.MARKER>

RETURN

*-----------------------
GET.SUNNEL.METHOD.VALUE:
*-----------------------

    Y.METHOD.NAME = R.REDO.SUNNEL.METHOD<RE.GE.METHOD.NAME>
    Y.APPLICATION = R.REDO.SUNNEL.METHOD<RE.GE.APPLICATION>
    Y.CODE.FIELD  = R.REDO.SUNNEL.METHOD<RE.GE.MSG.CODE.FLD>
    Y.MSG.FIELD   = R.REDO.SUNNEL.METHOD<RE.GE.MSG.DESC.FLD>

    CHANGE @VM TO @FM IN Y.APPLICATION
    LOCATE "CUSTOMER" IN Y.APPLICATION  SETTING Y.APP.POS ELSE
        Y.APP.POS=1
    END
    Y.FIELD.IN    = R.REDO.SUNNEL.METHOD<RE.GE.T24.IN,Y.APP.POS>
    Y.FIELD.NAME  = R.REDO.SUNNEL.METHOD<RE.GE.FLD.NAME,Y.APP.POS>
    Y.FIELD.TYPE  = R.REDO.SUNNEL.METHOD<RE.GE.FLD.TYPE,Y.APP.POS>
    Y.FIELD.OUT   = R.REDO.SUNNEL.METHOD<RE.GE.T24.OUT,Y.APP.POS>
    Y.OUT.NAME    = R.REDO.SUNNEL.METHOD<RE.GE.OT.NAME,Y.APP.POS>
    Y.OUT.TYPE    = R.REDO.SUNNEL.METHOD<RE.GE.OT.TYPE,Y.APP.POS>

    CHANGE @SM TO @FM IN Y.FIELD.IN
    CHANGE @SM TO @FM IN Y.FIELD.NAME
    CHANGE @SM TO @FM IN Y.FIELD.TYPE
    CHANGE @SM TO @FM IN Y.FIELD.OUT
    CHANGE @SM TO @FM IN Y.OUT.NAME
    CHANGE @SM TO @FM IN Y.OUT.TYPE
RETURN

*--------------
UPDATE.C22.LOG:
*--------------

    INT.CODE = 'N27001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    MON.TP   = '03'
    DESC     = Y.ARRAY<4>
    REC.CON  = ''
    EX.USER  = ''
    EX.PC    = ''
*    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
RETURN

*-------
WR.CUST:
*-------
* Upgrade Change 20161121 Start
    IF Y.CUST.STATUS NE '' AND (R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> NE Y.CUST.STATUS) THEN
* Upgrade Change 20161121 End
        R.CUSTOMER<EB.CUS.CUSTOMER.STATUS> = Y.CUST.STATUS
        CALL F.WRITE(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER)
    END
RETURN

END
