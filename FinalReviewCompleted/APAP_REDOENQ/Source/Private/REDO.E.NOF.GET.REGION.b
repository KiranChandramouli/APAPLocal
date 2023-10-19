$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.GET.REGION(Y.ACC.ID,Y.REGION.VAL,Y.REGION,Y.REGION.NUMBER,Y.REGION.FLAG)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.NOF.LOAN.EXP.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : CALL routine used to calculate the region value and DAO officer name
*In Parameter : Y.REGION.VAL,Y.ACC.ID
*Out Parameter: Y.REGION.FLAG,Y.REGION.NUMBER,Y.REGION
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
*  15th SEPT 2010   JEEVA T              ODR-2010-03-0152        Initial Creation
*                                        ODR-2010-03-0171
* 12-APRIL-2023      Harsha                R22 Auto Conversion  - F.READ to CACHE.READ , FM to @FM and VM to @VM
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.DEPT.ACCT.OFFICER

    GOSUB OPEN.FILE
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------
OPEN.FILE:
*-----------------------------------------------------------------------------
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.DEPT.ACCT.OFFICER='F.DEPT.ACCT.OFFICER'
    F.DEPT.ACCT.OFFICER=''
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)

RETURN
*-------------------------------------------------------------------------
PROCESS.PARA:
*-------------------------------------------------------------------------
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
    Y.ACC.OFF =R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.CNT = LEN(Y.ACC.OFF)
    Y.CNT1 = Y.CNT-8
    Y.CNT2 = Y.CNT1+1
    Y.BDY.REGION = Y.ACC.OFF[Y.CNT2,2]

    IF Y.CNT EQ 8 THEN
        Y.BDY.REGION = Y.ACC.OFF[1,2]
    END

    IF Y.REGION.VAL NE '' THEN

        IF Y.ACC.OFF EQ Y.REGION.VAL THEN
            Y.REGION.NUMBER=Y.BDY.REGION
            CALL CACHE.READ(FN.DEPT.ACCT.OFFICER, Y.BDY.REGION, R.DEPT.ACCT.OFFICER, F.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
            Y.REGION=R.DEPT.ACCT.OFFICER<EB.DAO.NAME>
            CHANGE @FM TO @VM IN Y.REGION
        END ELSE
            Y.REGION.FLAG='1'
        END

    END ELSE

        Y.REGION.NUMBER=Y.BDY.REGION
        CALL CACHE.READ(FN.DEPT.ACCT.OFFICER, Y.BDY.REGION, R.DEPT.ACCT.OFFICER, F.ERR)		;*R22 Auto Conversion  - F.READ to CACHE.READ
        Y.REGION=R.DEPT.ACCT.OFFICER<EB.DAO.NAME>
        CHANGE @FM TO @VM IN Y.REGION

    END
* PACS00312713 - S
    Y.LEN.REGNO = LEN(Y.REGION.NUMBER)
    IF Y.CNT LT 8 AND Y.LEN.REGNO GT 0 THEN
        Y.REGION.NUMBER = TRIM(FMT(Y.REGION.NUMBER,"2'0'R"))
    END
*
*    IF Y.CNT LE 7 THEN
*       Y.REGION.NUMBER=''
*    END
* PACS00312713 - E
RETURN
*-------------------------------------------------------------------------
END
