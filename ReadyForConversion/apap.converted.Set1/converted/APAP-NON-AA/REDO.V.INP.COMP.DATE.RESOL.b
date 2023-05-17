SUBROUTINE REDO.V.INP.COMP.DATE.RESOL
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION :A Validation routine is written to update the DATE.OF.RESOLUTION from the
*local parameter table REDO.SLA.PARAM
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.INP.COMP.DATE.RESOL
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE WHO REFERENCE DESCRIPTION
* 30.07.2010 SUDHARSANAN S ODR-2009-12-0283 INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.SLA.PARAM

    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.SLA.PARAM = 'F.REDO.SLA.PARAM'
    F.REDO.SLA.PARAM = ''
    CALL OPF(FN.REDO.SLA.PARAM,F.REDO.SLA.PARAM)

    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS, F.REDO.ISSUE.COMPLAINTST)

    LREF.APPLICATION = 'CUSTOMER'
    LREF.FIELD = 'L.CU.SEGMENTO'
    LREF.POS = ''
    CALL GET.LOC.REF(LREF.APPLICATION,LREF.FIELD,LREF.POS)
    L.CU.SEGMENTO.POS = LREF.POS
    FLAG = ''

RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------
    Y.CUS.ID = R.NEW(ISS.COMP.CUSTOMER.CODE)
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    CUS.SEGMENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS>
    CHANNEL.OPEN = R.NEW(ISS.COMP.OPENING.CHANNEL)
    CHANNEL.SEGEMENT = CHANNEL.OPEN:'-':CUS.SEGMENT
    DATE.TODAY = TODAY
    Y.TYPE = R.NEW(ISS.COMP.TYPE)
    Y.PRDT.TYPE = R.NEW(ISS.COMP.PRODUCT.TYPE)
    Y.DATE.RESOL.ID = Y.TYPE:'-':Y.PRDT.TYPE
    DESC.CLAIM = R.NEW(ISS.COMP.CLAIM.TYPE)
    DATE1 = R.NEW(ISS.COMP.OPENING.DATE)
    CALL F.READ(FN.REDO.SLA.PARAM,Y.DATE.RESOL.ID,R.REDO.SLA.PARAM,F.REDO.SLA.PARAM,SLA.ERR)
    DESC.SLA = R.REDO.SLA.PARAM<SLA.DESCRIPTION>
    CHANGE @VM TO @FM IN DESC.SLA
    LOCATE DESC.CLAIM IN DESC.SLA SETTING SLA.POS THEN
        Y.START.CHANNEL = R.REDO.SLA.PARAM<SLA.START.CHANNEL,SLA.POS>
        IF Y.START.CHANNEL THEN
            CHANGE @SM TO @FM IN Y.START.CHANNEL
            CNT1 = DCOUNT(Y.START.CHANNEL,@FM)
            CNT =1
            LOOP
            WHILE CNT LE CNT1
                IF Y.START.CHANNEL<CNT> EQ CHANNEL.SEGEMENT THEN
                    GOSUB UPDATE.DATE.RES
                    GOSUB UPDATE.SER.AGR.COMP
                    FLAG=1
                    BREAK
                END
                CNT += 1
            REPEAT
            IF FLAG EQ '' THEN
                GOSUB PROCESS1
            END
        END ELSE
            GOSUB PROCESS1
        END
    END
RETURN
*----------------------------------------------------------------------------------------------
UPDATE.DATE.RES:
*------------------------------------------------------------------------------------------
    DAYS.RESOL = R.REDO.SLA.PARAM<SLA.SEG.DAYS,SLA.POS,CNT>:'C'
    CALL CDT('',DATE.TODAY,DAYS.RESOL)
    R.NEW(ISS.COMP.DATE.RESOLUTION) = DATE.TODAY
RETURN
*------------------------------------------------------------------------------------------
UPDATE.SER.AGR.COMP:
*------------------------------------------------------------------------------------------
    DAYS.RESOL = R.REDO.SLA.PARAM<SLA.SEG.DAYS,SLA.POS,CNT>
    NO.OF.DAYS = 'C'
    CALL CDD('',DATE1,TODAY,NO.OF.DAYS)
    IF NO.OF.DAYS GT DAYS.RESOL THEN
        R.NEW(ISS.COMP.SER.AGR.COMP) = "EXPIRED"
    END ELSE
        R.NEW(ISS.COMP.SER.AGR.COMP) = "ONTIME"
    END
RETURN
*-----------------------------------------------------------------------------------------
PROCESS1:
*-----------------------------------------------------------------------------------------
    R.NEW(ISS.COMP.DATE.RESOLUTION) = TODAY
    DAYS.RESOL = 0
    NO.OF.DAYS = 'C'
    CALL CDD('',DATE1,TODAY,NO.OF.DAYS)
    IF NO.OF.DAYS GT DAYS.RESOL THEN
        R.NEW(ISS.COMP.SER.AGR.COMP) = "EXPIRED"
    END ELSE
        R.NEW(ISS.COMP.SER.AGR.COMP) = "ONTIME"
    END
RETURN
*-------------------------------------------------------------------------------------------
END
