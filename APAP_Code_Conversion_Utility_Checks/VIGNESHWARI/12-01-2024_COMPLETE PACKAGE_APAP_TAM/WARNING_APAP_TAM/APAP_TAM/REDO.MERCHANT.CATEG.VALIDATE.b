* @ValidationCode : MjotMTQxNDM2MDA5OTpVVEYtODoxNzA0OTU1NTM3NzY1OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 12:15:37
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.MERCHANT.CATEG.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.MERCHANT.CATEG.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a  Validate routine to check entered merchant code is correct or not
*Linked With  : REDO.ACCT.IST.RESP.MAP
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27 Oct 2010     Swaminathan.S.R       ODR-2009-12-0291         Initial Creation
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*12/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION              Y.CNT + 1 TO += 1,  VM TO @VM
*12/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE

*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG
    $INSERT I_F.REDO.MERCHANT.CATEG
    $INSERT I_F.REDO.MERCHANT.TYPE



    GOSUB PROCESS.PARA

RETURN

**************
PROCESS.PARA:
**************
    IF V$FUNCTION EQ 'I' THEN
        FN.REDO.MERCHANT.CATEG= 'F.REDO.MERCHANT.CATEG'
        F.REDO.MERCHANT.CATEG = ''
        CALL OPF(FN.REDO.MERCHANT.CATEG,F.REDO.MERCHANT.CATEG)

        FN.REDO.MERCHANT.TYPE= 'F.REDO.MERCHANT.TYPE'
        F.REDO.MERCHANT.TYPE = ''
        CALL OPF(FN.REDO.MERCHANT.TYPE,F.REDO.MERCHANT.TYPE)

        GOSUB VALIDATE.PARA
    END
RETURN

***************
VALIDATE.PARA:
***************

    Y.STATUS.COUNT = DCOUNT(R.NEW(REDO.MERCHANT.CATEG.MERCHANT.TYPE),@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.STATUS.COUNT
        Y.STAT.CODE = R.NEW(REDO.MERCHANT.CATEG.MERCHANT.TYPE)<1,Y.CNT>
*********MERCHANT CODE CHECK********
*    CALL F.READ(FN.REDO.MERCHANT.TYPE,"SYSTEM",R.REDO.MERCHANT.TYPE,F.REDO.MERCHANT.TYPE,Y.ERR.MER.TYPE) ;*Tus Start
*        CALL CACHE.READ(FN.REDO.MERCHANT.TYPE,"SYSTEM",R.REDO.MERCHANT.TYPE,Y.ERR.MER.TYPE) ; * Tus End
        IDVAR.1 = "SYSTEM" ;* R22 UTILITY AUTO CONVERSION
        CALL CACHE.READ(FN.REDO.MERCHANT.TYPE,IDVAR.1,R.REDO.MERCHANT.TYPE,Y.ERR.MER.TYPE) ; * Tus End;* R22 UTILITY AUTO CONVERSION
        Y.MER.TYPE = R.REDO.MERCHANT.TYPE<REDO.MERCHANT.TYPE.MERCHANT.TYPE>
        LOCATE Y.STAT.CODE IN Y.MER.TYPE<1,1> SETTING MER.POS THEN
        END ELSE
            AF = REDO.MERCHANT.CATEG.MERCHANT.TYPE
            ETEXT = "EB-VALID.MERCHANT.TYPE"
            CALL STORE.END.ERROR
        END
        Y.CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
RETURN
END
