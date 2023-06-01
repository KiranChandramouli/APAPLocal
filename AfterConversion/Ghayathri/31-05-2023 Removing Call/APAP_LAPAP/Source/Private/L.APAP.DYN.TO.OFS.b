* @ValidationCode : MjoxNDQ4MTY0OTY4OkNwMTI1MjoxNjgyMzMxMzIxNDY1OklUU1M6LTE6LTE6LTE2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -16
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE  L.APAP.DYN.TO.OFS(Y.DYN.REQUEST.OFS.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.OFS.TYPE, Y.ADDNL.INFO, Y.OFS.IN.REQUEST, Y.ERROR)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       + to EQ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion
    $INSERT I_EQUATE ;*R22 Auto conversion

*Subroutine Convert a Dynamic Array to OFS
*----------------------------------------------------------------------------------------------------------------------------------------------------
*Y.ADDNL.INFO
*<1>OBJECT.TYPE: VERSION/ENQUIRY/ROUTINE
*<2>APP.NAME : Application Name
*<3>OFSFUNCT : I = INPUT, A = AUTHORIZE, S = SEE, D = DELETE, R = REVERS, V = VERIFY
*<4>PROCESS : PROCESS = process, VERIFY = verify only, VALIDATE = process without saving
*<5>OFSVERSION : the version
*<6>GTSMODE : GTS Control value
*<7>NO.OF.AUTH : no of authorisers
*<8>CO.CODE: Company code
*<9>T24 USER
*<10>T24 USER PASSWORD


*Controls how GTS and OFS will handle error conditions for activities using this version record. The following values are allowed :
*Null (Reject errors / Approve overrides)
*GTS
*Validation errors will result in the record being rejected, the GTS data record in the output directory will be appended with an error code (90) Overrides will be accepted by default, the GTS data record in the output directory will be appended with the acceptance code (00).
*OFS
*Validation errors will result in the record being rejected, the OFS data record will be returned with details of the error message. Overrides will be accepted by default, the overrides will be returned in the populated OFS data record.
*1 (Errors on HLD / Approve Overrides)
*
*GTS
*Validation errors will place the record on hold, the GTS data record in the output directory will be appended with an error code (80). Overrides will be accepted by default the GTS data record in the output directory will be appended with the acceptance code (00).
*OFS
*Validation errors will place the record on hold, the OFS data record will be returned with the error messages. Overrides will be accepted by default, the values approved will be returned in the populated OFS record.
*2 (Errors Rejected / Overrides in HLD)
*
*GTS
*Validation errors will result in the record being rejected, the GTS data record in the output directory will be appended with an error code (90). Overrides will result in the record being placed on hold, the GTS data record in the output directory will be appended with an error code (81).
*
*OFS
*Validation errors will result in the record being rejected, the OFS data record will be returned with the error messages. Overrides will result in the record being placed on hold.
*3 (Errors in HLD / Overrides HLD)
*
*GTS
*Validation errors will place the record on hold, the GTS data record in the output directory will be appended with an error code (80). Overrides will result in the record being placed on hold, the GTS data record in the output directory will be appended with an error code (81).
*OFS
*Validation errors will place the record on hold, the OFS data record will be returned with the error messages. Overrides will result in the record being placed on hold, the OFS data record returned will store the override message.
*4 (Hold Only)
*
*GTS
*This option is not available using GTS. Messages can be written straight to HLD using the GTS.MODE field in GT.SYSTEM.PARAMETER.
*OFS
*If field validation (FIELD.VAL in OFS.SOURCE) is not set then this setting will place all records in HLD status immediately, and no further validation or processing will take place. If field validation is set (FIELD.VAL=YES) then any field validation errors will cause the record put into HLD also OFS data record will be returned with the error messages.
*
*Validation Rules:
*1 character numeric must be either null (no value), 1 ,2, 3 or 4.

*TEMPLATE
*Transaction Request
*OPERATION,OPTIONS,USER INFORMATION,TRANSACTION ID,DATA
*APP.NAME,VERSION/OFSFUNCT/PROCESS/GTSMODE/NO.OF.AUTH,USERNAME/USERPASS/CO.CODE,@ID,DATA:1:1="TEST"

*Enquiry Request
*ENQUIRY.SELECT,,USER INFORMATION,ENQUIRY,DATA
*ENQUIRY.SELECT,,USERNAME/USERPASS,%ENQ.NAME,@ID:EQ=111

*CLEAR OUTPUTS VARIABLES
    Y.OFS.IN.REQUEST = ''
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.DYN.TO.OFS'

    Y.FIELD.CNT = DCOUNT(Y.DYN.REQUEST.OFS.KEY, @FM)
    Y.MV.CNT = 0
    Y.SM.CNT = 0

    Y.OFS.FIELD.KV.FIELD = ''
    Y.OFS.FIELD.KV.VALUE = ''
    Y.OFS.FIELD.KV = ''
    Y.OFS.DATA = ''

    Y.OFS.TRANSACTION.ID = ''

    FOR V.I = 1 TO Y.FIELD.CNT STEP 1
*DEBUG
        Y.OFS.FIELD.KV  = ''
        IF Y.DYN.REQUEST.OFS.KEY<V.I> NE '*' THEN
            IF Y.DYN.REQUEST.OFS.KEY<V.I> EQ 'ID' OR Y.DYN.REQUEST.OFS.KEY<V.I>  EQ '@ID' THEN
                Y.OFS.TRANSACTION.ID = Y.DYN.REQUEST.VALUE<V.I>
            END
            ELSE
                IF Y.DYN.REQUEST.OFS.TYPE<V.I> EQ 'S' THEN
                    Y.OFS.FIELD.KV  = Y.DYN.REQUEST.OFS.KEY<V.I> : ':1:1='  :  Y.DYN.REQUEST.VALUE<V.I> : ''
                    IF Y.OFS.DATA EQ '' THEN
                        Y.OFS.DATA = Y.OFS.FIELD.KV
                    END
                    ELSE
                        Y.OFS.DATA := ',' : Y.OFS.FIELD.KV
                    END
                END
                ELSE
*DEBUG
                    Y.MV.CNT = DCOUNT(Y.DYN.REQUEST.VALUE<V.I>,@VM)
                    FOR V.J = 1 TO Y.MV.CNT STEP 1
                        Y.SM.CNT = DCOUNT(Y.DYN.REQUEST.VALUE<V.I, V.J>,@SM)
                        FOR V.K = 1 TO Y.SM.CNT STEP 1

                            Y.OFS.FIELD.KV.FIELD = Y.DYN.REQUEST.OFS.KEY<V.I> : ':' : V.J : ':' : V.K
                            Y.OFS.FIELD.KV.VALUE = '' : Y.DYN.REQUEST.VALUE<V.I, V.J, V.K> : ''
                            Y.OFS.FIELD.KV  = Y.OFS.FIELD.KV.FIELD : '=' : Y.OFS.FIELD.KV.VALUE

                            IF Y.OFS.DATA EQ '' THEN
                                Y.OFS.DATA = Y.OFS.FIELD.KV
                            END
                            ELSE
                                Y.OFS.DATA := ',' : Y.OFS.FIELD.KV
                            END
                        NEXT V.K
                    NEXT V.J
                END
            END
        END
    NEXT V.I

*DEBUG
    Y.OBJECT.TYPE = Y.ADDNL.INFO<1>
    BEGIN CASE
        CASE Y.OBJECT.TYPE EQ 'VERSION'
            GOSUB VERSIONREQ
        CASE Y.OBJECT.TYPE  EQ 'ENQUIRY'
            GOSUB ENQUIRYREQ
        CASE 1
            Y.ERROR<1> = 1
            Y.ERROR<2> = 'INVALID OFS REQUEST'
            RETURN
    END CASE
RETURN

VERSIONREQ:
*DEBUG
    Y.OFS.OPERATION = Y.ADDNL.INFO<2>
    Y.OFS.OPTIONS = Y.ADDNL.INFO<5> : '/' : Y.ADDNL.INFO<3> : '/' : Y.ADDNL.INFO<4> : '/' : Y.ADDNL.INFO<6> : '/' : Y.ADDNL.INFO<7>
    Y.OFS.USER.INFORMATION = Y.ADDNL.INFO<9> : '/' : Y.ADDNL.INFO<10> : '/' : Y.ADDNL.INFO<8>
*Y.OFS.TRANSACTION.ID
    Y.OFS.IN.REQUEST =  Y.OFS.OPERATION : ',' :  Y.OFS.OPTIONS  : ',' :  Y.OFS.USER.INFORMATION : ',' :  Y.OFS.TRANSACTION.ID  : ',' : Y.OFS.DATA
RETURN

ENQUIRYREQ:
*DEBUG
    Y.OFS.OPERATION = 'ENQUIRY.SELECT'
    Y.OFS.OPTIONS = ''
    Y.OFS.USER.INFORMATION = Y.ADDNL.INFO<9> : '/' : Y.ADDNL.INFO<10> : '/' : Y.ADDNL.INFO<8>
    Y.OFS.TRANSACTION.ID = Y.ADDNL.INFO<2>
    Y.OFS.IN.REQUEST =  Y.OFS.OPERATION : ',' :  Y.OFS.OPTIONS  : ',' :  Y.OFS.USER.INFORMATION : ',' :  Y.OFS.TRANSACTION.ID  : ',' : Y.OFS.DATA
RETURN

RETURN
END
