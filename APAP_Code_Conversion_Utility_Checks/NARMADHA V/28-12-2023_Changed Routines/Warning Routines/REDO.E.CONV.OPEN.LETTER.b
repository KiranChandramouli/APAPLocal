* @ValidationCode : MjotOTYyOTc5NzM2OlVURi04OjE3MDM3Njk5Nzk3NjM6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Dec 2023 18:56:19
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
SUBROUTINE REDO.E.CONV.OPEN.LETTER
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Conversion routien to fetch the SEGMENT.DAYS from Parameter table
* REDO.SLA.PARAM
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : B RENUGADEVI
* PROGRAM NAME : REDO.E.CONV.OPEN.LETTER
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 20-AUG-2010       BRENUGADEVI        ODR-2009-12-0283  INITIAL CREATION

* 13-APR-2023     Conversion tool   R22 Auto conversion     FM TO @FM, VM to @VM, SM to @SM, ++ to +=
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 28-12-2023       Narmadha V       Manual R22 Conversion   F.READ to CACHE.READ
* ----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.SLA.PARAM

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****

    SEGMENT.CHANNEL         = ''
    FN.CUSTOMER             = 'F.CUSTOMER'
    F.CUSTOMER              = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.SLA.PARAM       = 'F.REDO.SLA.PARAM'
    F.REDO.SLA.PARAM        = ''
    CALL OPF(FN.REDO.SLA.PARAM,F.REDO.SLA.PARAM)

    LREF.APPL                = 'CUSTOMER'
    LREF.FIELDS              = 'L.CU.SEGMENTO'
    LREF.POS                 = ''
    CALL MULTI.GET.LOC.REF(LREF.APPL, LREF.FIELDS, LREF.POS)
    L.CU.SEGMENTO.POS      = LREF.POS<1,1>
RETURN

********
PROCESS:
********


    Y.ODATA         = O.DATA
    Y.CUS.ID        = FIELD(Y.ODATA,'*',1)
    Y.TYPE          = FIELD(Y.ODATA,'*',2)
    Y.OPEN.CHANNEL  = FIELD(Y.ODATA,'*',3)
    Y.PRODUCT       = FIELD(Y.ODATA,'*',4)
    Y.DESCRIPTION   = FIELD(Y.ODATA,'*',5)

    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
    IF R.CUSTOMER THEN
        Y.SEGMENT  = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS>
    END

    Y.SLA.ID        = Y.TYPE:'-':Y.PRODUCT
    SEGMENT.CHANNEL = Y.OPEN.CHANNEL:'-':Y.SEGMENT
*CALL F.READ(FN.REDO.SLA.PARAM,Y.SLA.ID,R.SLA,F.REDO.SLA.PARAM,SLA.ERR)
    CALL CACHE.READ(FN.REDO.SLA.PARAM,Y.SLA.ID,R.SLA,SLA.ERR) ;*Manual R22 Conversion - F.READ to CACHE.READ
    IF SLA.ERR THEN
*CALL F.READ(FN.REDO.SLA.PARAM,Y.TYPE,R.SLA,F.REDO.SLA.PARAM,SLA.ERR)
        CALL CACHE.READ(FN.REDO.SLA.PARAM,Y.TYPE,R.SLA,SLA.ERR) ;*Manual R22 Conversion - F.READ to CACHE.READ
    END
    IF Y.TYPE EQ 'QUEJAS' THEN
        Y.START.CHANNEL        = R.SLA<SLA.START.CHANNEL>
        GOSUB FETCH.DAYS
        GOSUB PGM.END
    END

    IF R.SLA THEN
        DESC.SLA = R.SLA<SLA.DESCRIPTION>
        CHANGE @VM TO @FM IN DESC.SLA
        LOCATE Y.DESCRIPTION IN DESC.SLA SETTING SLA.POS THEN
            Y.START.CHANNEL        = R.SLA<SLA.START.CHANNEL,SLA.POS>
            GOSUB FETCH.DAYS
            GOSUB PGM.END
        END ELSE
            O.DATA = ''
        END
    END  ELSE
        O.DATA  = ''
    END
RETURN
************
FETCH.DAYS:
************

    IF Y.START.CHANNEL EQ '' OR Y.SEGMENT EQ '' THEN
        O.DATA  = ''
    END ELSE
        CHANGE @SM TO @FM IN Y.START.CHANNEL
        CNT1 = DCOUNT(Y.START.CHANNEL,@FM)
        CNT =1
        LOOP
        WHILE CNT LE CNT1
            IF Y.START.CHANNEL<CNT> EQ SEGMENT.CHANNEL THEN
                DAYS.RESOL     = R.SLA<SLA.SEG.DAYS,SLA.POS,CNT>
                IF DAYS.RESOL THEN
                    O.DATA         = DAYS.RESOL
                    Y.FLAG = 1
                END
            END
            CNT += 1
        REPEAT
    END
    IF NOT(Y.FLAG) THEN
        O.DATA  = ''
    END
RETURN

PGM.END:
********
END
*----------------------------------------------------------------------------------------------------
