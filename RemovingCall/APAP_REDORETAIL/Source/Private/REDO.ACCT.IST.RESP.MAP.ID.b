* @ValidationCode : MjotODI0NzcyMTQ5OkNwMTI1MjoxNjgxMjgzOTI4ODA3OklUU1M6LTE6LTE6OTI6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 92
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACCT.IST.RESP.MAP.ID
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ACCT.IST.RESP.MAP.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to check entered status code is correct or not
*Linked With  : REDO.ACCT.IST.RESP.MAP
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27 Oct 2010     Swaminathan.S.R                                Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION            NO CHANGES
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG
    $INSERT I_F.REDO.ACCT.STATUS.CODE

    IF GTSACTIVE THEN
        IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN
            GOSUB PROCESS.PARA
            RETURN
        END
    END ELSE
        GOSUB PROCESS.PARA
    END
RETURN

**************
PROCESS.PARA:
**************
    IF V$FUNCTION EQ 'I' THEN
        FN.REDO.ACCT.STATUS.CODE = 'F.REDO.ACCT.STATUS.CODE'
        F.REDO.ACCT.STATUS.CODE = ''
        CALL OPF(FN.REDO.ACCT.STATUS.CODE,F.REDO.ACCT.STATUS.CODE)
*CALL F.READ(FN.REDO.ACCT.STATUS.CODE,"SYSTEM",R.REDO.ACCT.STATUS.CODE,F.REDO.ACCT.STATUS.CODE,Y.ERR.ACT.STAT.CODE)
        CALL CACHE.READ(FN.REDO.ACCT.STATUS.CODE,"SYSTEM",R.REDO.ACCT.STATUS.CODE,Y.ERR.ACT.STAT.CODE)
        Y.STATUS.CODE = ID.NEW
        Y.ACCT.STATUS.CODE = R.REDO.ACCT.STATUS.CODE<REDO.ACCT.STATUS.STATUS.CODE>
        LOCATE Y.STATUS.CODE IN Y.ACCT.STATUS.CODE<1,1> SETTING STAT.POS THEN
        END ELSE
            E = "EB-VALID.STATUS.CODE"
            CALL STORE.END.ERROR
        END
    END
RETURN
END
