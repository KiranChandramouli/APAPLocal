* @ValidationCode : MjotNjY4NDYxNTU1OkNwMTI1MjoxNjgxOTk1OTg1OTc2OklUU1M6LTE6LTE6LTE3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -17
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.BILL.TYPE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.BILL.TYPE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a converstion routine to ge the EB.LOOKUP value for BILL.COND
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  06Apr2011       Pradeep S            PACS00052995             Initial Creation
* 13-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, ++ to +=, CONVERT to CHANGE
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    GOSUB PROCESS

RETURN

*========
PROCESS:
*=======

    Y.BILL.COND = O.DATA
    CHANGE @VM TO @FM IN Y.BILL.COND ;*R22 Auto conversion
    Y.CNT.VALUES = DCOUNT(Y.BILL.COND,@FM)

    VAR.VIRTUAL.TABLE = 'BILL.TYPE'

    Y.VALUES = Y.BILL.COND
    GOSUB GET.VALUES
    O.DATA = Y.BILL.VAL


RETURN


*=====================
GET.VALUES:
*======================

    VIRTUAL.TABLE.IDS = ''
    VIRTUAL.TABLE.VALUES = ''
    Y.BILL.VAL = ''

    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part of @ID
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>      ;*Description field values
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS

    CNT =1
    LOOP
    WHILE CNT LE Y.CNT.VALUES
        TABLE.IDS = ''
        TABLE.IDS = Y.VALUES<CNT>
        LOCATE TABLE.IDS IN VIRTUAL.TABLE.IDS SETTING POS THEN
            Y.BILL.VAL<1,-1> = VIRTUAL.TABLE.VALUES<POS>
        END
        CNT += 1
    REPEAT

RETURN

END
